FROM registry.access.redhat.com/ubi8/ubi:8.0

ENV X_SCLS="rh-nginx18" \
    PATH="/opt/rh/rh-nginx18/root/usr/sbin:$PATH" \
    NGINX_DOCROOT="/usr/share/nginx/html"

ENV NAME=nginx \
    NGINX_VERSION=1.12 \
    NGINX_SHORT_VER=12 \
    VERSION=0

LABEL io.k8s.description="A Nginx S2I builder image" \
      io.k8s.display-name="Nginx 1.8 S2I builder image for DO288" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="builder,webserver,nginx,nginx18,html"

ENV NGINX_CONFIGURATION_PATH=${APP_ROOT}/etc/nginx.d \
    NGINX_CONF_PATH=/etc/opt/rh/rh-nginx${NGINX_SHORT_VER}/nginx/nginx.conf \
    NGINX_DEFAULT_CONF_PATH=${APP_ROOT}/etc/nginx.default.d \
    NGINX_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
    NGINX_APP_ROOT=${APP_ROOT} \
    NGINX_LOG_PATH=/var/opt/rh/rh-nginx${NGINX_SHORT_VER}/log/nginx \
    NGINX_PERL_MODULE_PATH=${APP_ROOT}/etc/perl

COPY ./s2i/bin/ /usr/libexec/s2i

RUN yum install -y --nodocs nginx \
  &&  yum clean all \
  && chgrp -R 0 /etc/nginx /usr/share/nginx/html \
  && chmod -R g=u /etc/nginx /usr/share/nginx/html

EXPOSE 8080

USER 1001

CMD ["/usr/libexec/s2i/usage"]


