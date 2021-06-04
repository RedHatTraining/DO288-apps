This Dockerfile is a combination of the two Dockerfiles:

* https://github.com/sonatype/docker-nexus3/blob/3.30.1/Dockerfile
* https://github.com/sonatype/docker-nexus3/blob/3.30.1/Dockerfile.rh.el

Both Dockerfiles use Chef recipes to install Nexus.  These Chef recipes are
downloaded during the build by the Dockerfile.

The first Dockerfile uses the ubi8/ubi image, but is missing LABEL(s) that OpenShift
and Kubernetes use.  This Dockerfile also uses an ENTRYPOINT to account for OpenShift
assigning a random UID for each container.

The second Dockerfile includes the LABELs needed by Kubernetes and OpenShift,
but does not use UBI and does not indicate how it handles the random UID.
Testing an image off of this Dockerfile shows that there is no issue with the
image running.

