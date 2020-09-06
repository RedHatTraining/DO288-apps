# Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent
#EXPOSE 8080
#LABEL io.opeshift.expose-services="8080:http"
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
