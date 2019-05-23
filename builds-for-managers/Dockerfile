FROM   registry.centos.org/centos/centos:centos7

MAINTAINER   Red Hat Training <training@redhat.com>

# command line options to pass to the JVM
ENV	  JAVA_OPTIONS -Xmx512m

# Install the Java runtime, create a user for running the app, and set permissions
RUN   rpm --rebuilddb && \
      yum install -y --noplugins java-1.8.0-openjdk-headless && \
      yum clean all --noplugins -y && \
      mkdir -p /opt/app-root/bin

# Copy the runnable fat JAR to the container.
ADD   app-src/target/builds-for-managers-swarm.jar /opt/app-root/bin/builds-for-managers.jar

COPY  run-app.sh /opt/app-root/bin/

RUN   chgrp -R 0 /opt/app-root && \
      chmod -R g=u /opt/app-root

EXPOSE 8080

USER  1001

# Run the fat JAR
CMD   /opt/app-root/bin/run-app.sh
