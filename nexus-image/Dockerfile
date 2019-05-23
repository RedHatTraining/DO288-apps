FROM rhel7:7.6

MAINTAINER Red Hat Training

ARG NEXUS_VERSION=2.14.3-02
ARG NEXUS_DOWNLOAD_URL=http://content.example.com/ocp3.6/x86_64/installers/nexus-${NEXUS_VERSION}-bundle.tar.gz

ENV SONATYPE_WORK=/sonatype-work \
    USER_NAME=nexus \
    USER_UID=200


ADD usr/local/bin/fix-permissions.sh /usr/local/bin/fix-permissions.sh
ADD probes/liveness.sh /usr/local/bin/liveness.sh
ADD probes/readiness.sh /usr/local/bin/readiness.sh
ADD uid_entrypoint /

#install tools and Java
RUN rpm --rebuilddb && \
  yum install -y \
  curl tar createrepo java-1.8.0-openjdk-devel \
  && yum clean all \
  #install nexus
  && mkdir -p /opt/sonatype/nexus \
  && mkdir ${SONATYPE_WORK} \
  && curl --fail --silent --location --retry 3 \
    ${NEXUS_DOWNLOAD_URL} \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION} \
  #create a user for nexus
  && useradd -r -u 200 -m -c "nexus role account" -s /bin/false nexus \
  #fix permissions
  &&  chmod 755 /usr/local/bin/fix-permissions.sh \
  && chmod 755 /usr/local/bin/liveness.sh \
  && chmod 755 /usr/local/bin/readiness.sh \
  && chmod ug+x /uid_entrypoint \
  && chmod g+rw /etc/passwd \
  && /usr/local/bin/fix-permissions.sh /opt/sonatype \
  && /usr/local/bin/fix-permissions.sh ${SONATYPE_WORK}


# arbitrary uid recognition at runtime - for OpenShift deployments
RUN sed "s@${USER_NAME}:x:${USER_UID}:@${USER_NAME}:x:\${USER_ID}:@g" /etc/passwd > /etc/passwd.template

#Expose the nexus port
EXPOSE 8081

#Configure the workdir
WORKDIR /opt/sonatype/nexus

USER nexus

ENV CONTEXT_PATH /nexus \
  MAX_HEAP 768m \
  MIN_HEAP 256m \
  JAVA_OPTS -server -Djava.net.preferIPv4Stack=true \
  LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-requestlog.xml


ENTRYPOINT [ "/uid_entrypoint" ]

CMD java \
  -Dnexus-work=${SONATYPE_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} \
  -Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
  -cp 'conf/:lib/*' \
  ${JAVA_OPTS} \
  org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}

