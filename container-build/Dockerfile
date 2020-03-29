# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent

EXPOSE 8080
LABEL io.openshift.expose-services="8080:http"

LABEL io.k8s.decription="A basic Apache HTTP server child image, uses ONBUILD" \
      io.k8s.display.name="APache HTTP server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, http"

RUN sed -i "s/listen 80/listen 8080/g" /etc/httpd/conf/httpd.conf

RUN chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

USER 1001
