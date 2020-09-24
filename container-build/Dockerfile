# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent


RUN chgrp -R 0 /run/httpd && \
    chmod -R g=u /run/httpd

USER 1001
