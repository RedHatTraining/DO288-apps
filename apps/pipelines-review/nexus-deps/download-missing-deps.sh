#!/bin/bash
# Downloads surefire-junit4 provider dependencies missing from the classroom Nexus.
# Run this on a machine with internet access, then upload the files to Nexus.

CENTRAL="https://repo1.maven.org/maven2"
DEST="$(dirname "$0")/jars"
mkdir -p "${DEST}"

FILES=(
  # surefire-junit4 provider chain
  org/apache/maven/surefire/surefire-junit4/3.0.0-M5/surefire-junit4-3.0.0-M5.jar
  org/apache/maven/surefire/surefire-junit4/3.0.0-M5/surefire-junit4-3.0.0-M5.pom
  org/apache/maven/surefire/common-junit4/3.0.0-M5/common-junit4-3.0.0-M5.jar
  org/apache/maven/surefire/common-junit4/3.0.0-M5/common-junit4-3.0.0-M5.pom
  org/apache/maven/surefire/common-junit3/3.0.0-M5/common-junit3-3.0.0-M5.jar
  org/apache/maven/surefire/common-junit3/3.0.0-M5/common-junit3-3.0.0-M5.pom
  org/apache/maven/surefire/common-java5/3.0.0-M5/common-java5-3.0.0-M5.jar
  org/apache/maven/surefire/common-java5/3.0.0-M5/common-java5-3.0.0-M5.pom
  org/apache/maven/surefire/surefire-providers/3.0.0-M5/surefire-providers-3.0.0-M5.pom
  # plexus-utils 1.1
  org/codehaus/plexus/plexus-utils/1.1/plexus-utils-1.1.jar
)

echo "Downloading ${#FILES[@]} files to ${DEST}/"
for f in "${FILES[@]}"; do
  filename=$(basename "${f}")
  echo "  ${filename}"
  curl -sf -o "${DEST}/${filename}" "${CENTRAL}/${f}"
done
echo "Done. Files saved to ${DEST}/"
