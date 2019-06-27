FROM registry.access.redhat.com/ubi8:8.0

RUN yum install -y --disableplugin=subscription-manager --nodocs nginx \
  && yum clean all

ADD index.html /usr/share/nginx/html

ADD nginxconf.sed /tmp/
RUN sed -i -f /tmp/nginxconf.sed /etc/nginx/nginx.conf

RUN touch /run/nginx.pid \
  && chgrp -R 0 /var/log/nginx /run/nginx.pid \
  && chmod -R g+rwx /var/log/nginx /run/nginx.pid
  
EXPOSE 8080
USER 1001

CMD nginx -g "daemon off;"

