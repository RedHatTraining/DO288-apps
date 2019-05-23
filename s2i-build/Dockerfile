FROM registry.access.redhat.com/rhel7:7.6

MAINTAINER Red Hat Training <training@redhat.com>

# Generic labels
LABEL Component="httpd" \
      Name="s2i-do288-httpd" \
      Version="1.0" \
      Release="1"

# Labels consumed by OpenShift
LABEL io.k8s.description="A basic Apache HTTP Server S2I builder image" \
      io.k8s.display-name="Apache HTTP Server S2I builder image for DO288" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="apache, httpd, do288, s2i"

# Apache HTTP Server DocRoot
ENV DOCROOT /var/www/html

RUN   rpm --rebuilddb && \
      yum install -y --setopt=tsflags=nodocs --noplugins httpd && \
      yum clean all --noplugins -y && \
      echo "This is the default index page from the s2i-do288-httpd S2I builder image." > ${DOCROOT}/index.html

# Change web server port to 8080
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

# Copy the S2I scripts to the default location indicated by the io.openshift.s2i.scripts-url LABEL (default is /usr/libexec/s2i)
COPY ./.s2i/bin/ /usr/libexec/s2i

ENV APP_DIRS /var/www/ /run/httpd/ /etc/httpd/logs/ /var/log/httpd/

RUN chown -R 1001:1001 $APP_DIRS && \
    chgrp -R 0 $APP_DIRS && \
    chmod -R g=u $APP_DIRS

# This default user is created in the rhel7 image
USER 1001

EXPOSE 8080

CMD ["usage"]
