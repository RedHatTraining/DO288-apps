#!/bin/bash
# Uploads previously downloaded dependencies to the classroom Nexus java-hosted repo.

NEXUS_URL="http://nexus-infra.apps.lab.example.com"
REPO="java-hosted"
GROUP_REPO="java"
NEXUS_USER="admin"
NEXUS_PASS="admin123"
SRC="$(dirname "$0")/jars"
AUTH="-u ${NEXUS_USER}:${NEXUS_PASS}"

# Create the java-hosted repo if it does not exist
echo "Checking if ${REPO} repository exists..."
code=$(curl -s -o /dev/null -w "%{http_code}" ${AUTH} \
  "${NEXUS_URL}/service/rest/v1/repositories/maven/hosted/${REPO}")

if [ "${code}" = "404" ]; then
  echo "Creating ${REPO} repository..."
  curl -sf ${AUTH} -H 'Content-Type: application/json' \
    -d '{
      "name": "'"${REPO}"'",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true,
        "writePolicy": "ALLOW"
      },
      "maven": {
        "versionPolicy": "MIXED",
        "layoutPolicy": "PERMISSIVE"
      }
    }' \
    "${NEXUS_URL}/service/rest/v1/repositories/maven/hosted" \
    && echo "  Created." || { echo "  FAILED to create repo."; exit 1; }
else
  echo "  ${REPO} already exists."
fi

# Add java-hosted to the java group repo if not already a member
echo "Checking ${GROUP_REPO} group membership..."
members=$(curl -sf ${AUTH} "${NEXUS_URL}/service/rest/v1/repositories/maven/group/${GROUP_REPO}" \
  | python3 -c "import sys,json; print(','.join(json.load(sys.stdin)['group']['memberNames']))")

if echo "${members}" | grep -q "${REPO}"; then
  echo "  ${REPO} is already a member of ${GROUP_REPO}."
else
  echo "  Adding ${REPO} to ${GROUP_REPO} group..."
  new_members=$(echo "${members},${REPO}" | tr ',' '\n' | python3 -c "
import sys,json
print(json.dumps([ l.strip() for l in sys.stdin if l.strip() ]))")
  curl -sf -X PUT ${AUTH} -H 'Content-Type: application/json' \
    -d '{
      "name": "'"${GROUP_REPO}"'",
      "format": "maven2",
      "online": true,
      "storage": {
        "blobStoreName": "default",
        "strictContentTypeValidation": true
      },
      "group": {
        "memberNames": '"${new_members}"'
      }
    }' \
    "${NEXUS_URL}/service/rest/v1/repositories/maven/group/${GROUP_REPO}" \
    && echo "  Done." || { echo "  FAILED to update group."; exit 1; }
fi

upload() {
  local group="$1" artifact="$2" version="$3" file="$4" ext="$5"
  echo -n "  ${file} ... "
  code=$(curl -s -o /dev/null -w "%{http_code}" ${AUTH} \
    -F "maven2.groupId=${group}" \
    -F "maven2.artifactId=${artifact}" \
    -F "maven2.version=${version}" \
    -F "maven2.asset1=@${SRC}/${file}" \
    -F "maven2.asset1.extension=${ext}" \
    "${NEXUS_URL}/service/rest/v1/components?repository=${REPO}")
  echo "HTTP ${code}"
}

echo ""
echo "Uploading artifacts to ${NEXUS_URL}/repository/${REPO}"

upload org.apache.maven.surefire surefire-junit4   3.0.0-M5 surefire-junit4-3.0.0-M5.jar   jar
upload org.apache.maven.surefire surefire-junit4   3.0.0-M5 surefire-junit4-3.0.0-M5.pom   pom
upload org.apache.maven.surefire common-junit4     3.0.0-M5 common-junit4-3.0.0-M5.jar     jar
upload org.apache.maven.surefire common-junit4     3.0.0-M5 common-junit4-3.0.0-M5.pom     pom
upload org.apache.maven.surefire common-junit3     3.0.0-M5 common-junit3-3.0.0-M5.jar     jar
upload org.apache.maven.surefire common-junit3     3.0.0-M5 common-junit3-3.0.0-M5.pom     pom
upload org.apache.maven.surefire common-java5      3.0.0-M5 common-java5-3.0.0-M5.jar      jar
upload org.apache.maven.surefire common-java5      3.0.0-M5 common-java5-3.0.0-M5.pom      pom
upload org.apache.maven.surefire surefire-providers 3.0.0-M5 surefire-providers-3.0.0-M5.pom pom
upload org.codehaus.plexus       plexus-utils       1.1      plexus-utils-1.1.jar            jar

echo ""
echo "Verifying uploads via java group repo..."
ARTIFACTS=(
  org/apache/maven/surefire/surefire-junit4/3.0.0-M5/surefire-junit4-3.0.0-M5.jar
  org/apache/maven/surefire/common-junit4/3.0.0-M5/common-junit4-3.0.0-M5.jar
  org/apache/maven/surefire/common-junit3/3.0.0-M5/common-junit3-3.0.0-M5.jar
  org/apache/maven/surefire/common-java5/3.0.0-M5/common-java5-3.0.0-M5.jar
  org/apache/maven/surefire/surefire-providers/3.0.0-M5/surefire-providers-3.0.0-M5.pom
  org/codehaus/plexus/plexus-utils/1.1/plexus-utils-1.1.jar
)
for a in "${ARTIFACTS[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "${NEXUS_URL}/repository/java/${a}")
  echo "  $(basename ${a}): HTTP ${code}"
done
