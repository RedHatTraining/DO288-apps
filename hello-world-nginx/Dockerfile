FROM registry.access.redhat.com/rhel7:7.6

RUN 
  rpm --rebuilddb && \
  yum install -y --setopt=tsflags=nodocs rh-nginx18 \
  && yum clean all

ADD index.html /opt/rh/rh-nginx18/root/usr/share/nginx/html

ADD nginxconf.sed run.sh /tmp/
RUN sed -i -f /tmp/nginxconf.sed /etc/opt/rh/rh-nginx18/nginx/nginx.conf

RUN chown -R 1001:0 /var/opt/rh/rh-nginx18 /opt/rh/rh-nginx18 && \
    chmod -R a+rx,g+rwx /var/opt/rh/rh-nginx18 /opt/rh/rh-nginx18
  
EXPOSE 8080

USER 1001

ENTRYPOINT ["/tmp/run.sh"]

