# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent

MAINTAINER Red Hat Training <training@redhat.com>

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html

RUN yum install -y --no-docs --disableplugin=subscription-manager httpd && \ 
yum clean all --disableplugin=subscription-manager -y && \
Red Hat OpenShift Development I: Containerizing Applications - Student Workbook

echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

# Allows child images to inject their own content into DocumentRoot
ONBUILD COPY src/ ${DOCROOT}/

EXPOSE 80

# This stuff is needed to ensure a clean start RUN rm -rf /run/httpd && mkdir /run/httpd

# Run as the root user
USER root

# Launch httpd

CMD /usr/sbin/httpd -DFOREGROUND 
