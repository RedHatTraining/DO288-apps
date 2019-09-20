# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent

LABEL io.openshift.expose-service="8080:httpd"

EXPOSE 8080

RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd && \
    chgrp -R 0 /var/run/httpd && \
    chmod -R g=u /var/run/httpd && \
    chmod -R g=u /var/log/httpd

USER 1001

