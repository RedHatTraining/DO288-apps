# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent


RUN RUN chgrp -R 0 /some/directory && \
    chmod -R g=u /some/directory

USER 1001
