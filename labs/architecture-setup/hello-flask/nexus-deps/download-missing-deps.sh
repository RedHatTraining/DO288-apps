#!/bin/bash
# Downloads Python packages required by hello-flask that are missing from the classroom Nexus.
# Run this on a machine with internet access.

DEST="$(dirname "$0")/wheels"
mkdir -p "${DEST}"

PACKAGES=(
  Flask==2.1.0
  gunicorn==20.1.0
  click==8.1.7
  importlib-metadata==6.8.0
  itsdangerous==2.1.2
  Jinja2==3.1.2
  MarkupSafe==2.1.3
  Werkzeug==2.3.7
  zipp==3.17.0
)

# Download wheels for both Python 3.12 (workstation) and 3.9 (ubi8/python-39 container)
for pyver in 39 312; do
  echo "Downloading for cp${pyver}..."
  pip download \
    --dest "${DEST}" \
    --no-cache-dir \
    --python-version "${pyver}" \
    --only-binary=:all: \
    "${PACKAGES[@]}" 2>/dev/null || true
done

echo ""
echo "Done. Files saved to ${DEST}/"
ls -1 "${DEST}/"
