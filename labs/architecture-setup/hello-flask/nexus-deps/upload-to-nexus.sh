#!/bin/bash
# Uploads Python packages to the classroom Nexus.
# Converts the existing pypi proxy into a group so the pypi URL keeps working.

NEXUS_URL="http://nexus-infra.apps.lab.example.com"
NEXUS_USER="admin"
NEXUS_PASS="admin123"
SRC="$(dirname "$0")/wheels"
AUTH="-u ${NEXUS_USER}:${NEXUS_PASS}"

# Step 1: Create pypi-hosted repo if it does not exist
echo "Checking if pypi-hosted repository exists..."
code=$(curl -s -o /dev/null -w "%{http_code}" ${AUTH} \
  "${NEXUS_URL}/service/rest/v1/repositories/pypi/hosted/pypi-hosted")

if [ "${code}" = "404" ]; then
  echo "  Creating pypi-hosted..."
  curl -sf ${AUTH} -H 'Content-Type: application/json' \
    -d '{
      "name": "pypi-hosted",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true,
        "writePolicy": "ALLOW"
      }
    }' \
    "${NEXUS_URL}/service/rest/v1/repositories/pypi/hosted" \
    && echo "  Created." || { echo "  FAILED."; exit 1; }
else
  echo "  Already exists."
fi

# Step 2: Convert the pypi proxy into a group (pypi-proxy + pypi-hosted -> pypi)
echo ""
echo "Checking pypi repo type..."
pypi_type=$(curl -sf ${AUTH} "${NEXUS_URL}/service/rest/v1/repositories/pypi" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['type'])")

if [ "${pypi_type}" = "proxy" ]; then
  echo "  pypi is a proxy. Converting to group..."

  echo "  Deleting pypi proxy..."
  curl -sf -X DELETE ${AUTH} \
    "${NEXUS_URL}/service/rest/v1/repositories/pypi" \
    && echo "  Deleted." || { echo "  FAILED."; exit 1; }

  echo "  Creating pypi-proxy..."
  curl -sf ${AUTH} -H 'Content-Type: application/json' \
    -d '{
      "name": "pypi-proxy",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true
      },
      "proxy": {
        "remoteUrl": "https://pypi.org",
        "contentMaxAge": 1440,
        "metadataMaxAge": 1440
      },
      "httpClient": {
        "blocked": false,
        "autoBlock": true
      },
      "negativeCache": {
        "enabled": true,
        "timeToLive": 1440
      }
    }' \
    "${NEXUS_URL}/service/rest/v1/repositories/pypi/proxy" \
    && echo "  Created." || { echo "  FAILED."; exit 1; }

  echo "  Creating pypi group (pypi-hosted + pypi-proxy)..."
  curl -sf ${AUTH} -H 'Content-Type: application/json' \
    -d '{
      "name": "pypi",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true
      },
      "group": {
        "memberNames": ["pypi-hosted", "pypi-proxy"]
      }
    }' \
    "${NEXUS_URL}/service/rest/v1/repositories/pypi/group" \
    && echo "  Created." || { echo "  FAILED."; exit 1; }

elif [ "${pypi_type}" = "group" ]; then
  echo "  pypi is already a group."
  members=$(curl -sf ${AUTH} "${NEXUS_URL}/service/rest/v1/repositories/pypi/group/pypi" \
    | python3 -c "import sys,json; print(','.join(json.load(sys.stdin)['group']['memberNames']))")
  if ! echo "${members}" | grep -q "pypi-hosted"; then
    echo "  Adding pypi-hosted to group..."
    new_members=$(echo "${members},pypi-hosted" | tr ',' '\n' | python3 -c "
import sys,json
print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))")
    curl -sf -X PUT ${AUTH} -H 'Content-Type: application/json' \
      -d '{
        "name": "pypi",
        "format": "pypi",
        "online": true,
        "storage": {
          "blobStoreName": "default",
          "strictContentTypeValidation": true
        },
        "group": {
          "memberNames": '"${new_members}"'
        }
      }' \
      "${NEXUS_URL}/service/rest/v1/repositories/pypi/group/pypi" \
      && echo "  Done." || echo "  FAILED."
  fi
fi

# Step 3: Upload packages
echo ""
echo "Uploading packages to pypi-hosted..."
for f in "${SRC}"/*.whl "${SRC}"/*.tar.gz; do
  [ -f "${f}" ] || continue
  echo -n "  $(basename ${f}) ... "
  code=$(curl -s -o /dev/null -w "%{http_code}" ${AUTH} \
    -F "pypi.asset=@${f}" \
    "${NEXUS_URL}/service/rest/v1/components?repository=pypi-hosted")
  echo "HTTP ${code}"
done

# Step 4: Verify via pypi group
echo ""
echo "Verifying packages via pypi group..."
for pkg in flask gunicorn click importlib-metadata itsdangerous jinja2 markupsafe werkzeug zipp; do
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    "${NEXUS_URL}/repository/pypi/simple/${pkg}/")
  echo "  ${pkg}: HTTP ${code}"
done
