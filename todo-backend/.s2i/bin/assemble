#!/bin/bash

echo "Performing the S2I build..."

#TODO: add call to the standard S2I assemble script
/usr/libexec/s2i/assemble
rc=$?

if [ $rc -eq 0 ]; then
    echo "Recording successful build on the life cycle management system..."
else
    echo "Not calling the life cycle management system: S2I build failed!"
fi
exit $rc
