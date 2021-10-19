# How to customise a base image and publish it
## 1. DO288 way - do a local docker build and publish the child image
> Write a custom Dockerfile to overrid a standard docker image to use a non-privileged random user (1001) to run the container so that it can be deployed on OpenShift.
```
$ cd $HOME/DO288-apps/container-build
vim Dockerfile

## Use the httpd-parent image as base
FROM quay.io/redhattraining/httpd-parent

EXPOSE 8080

LABEL io.openshift.expose-services="8080:http"

LABEL io.k8s.description="A basic Apache HTTP Server child image, uses ONBUILD" \
io.k8s.display-name="Apache HTTP Server" \
io.openshift.expose-services="8080:http" \
io.openshift.tags="apache, httpd"

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

USER 1001
```
> Do a local docker build and push the child image to quay.io registry
```
$ docker build -t do288-apache .
$ ocker tag do288-apache quay.io/jackhu008/do288-apache
$ docker images
$ docker push quay.io/jackhu008/do288-apache
... go to quay.io website and make the image public
```
> deploy the child image to OpenShift
```
$ oc new-app --name hola quay.io/jackhu008/do288-apache
$ oc get svc
$ oc expose --port=8080 svc/hola; get route
$ curl hola-<project>.<clusterID>.eu-gb.containers.appdomain.cloud
```

## 2. OpenShift build and deployment - no local docker build
> Write a custom Dockerfile to overrid a standard docker image to use a non-privileged random user (1001) to run the container so that it can be deployed on OpenShift.
Same step as 1. DO288 way.
> Do an OpenShift new-app build and deployment in one go
```
$ oc new-app --name holav2 --strategy docker https://github.com/jackhu008/DO288-apps#master  --context-dir=container-build
$ oc logs -f bc/holav2
$ oc get pods -w
$ oc get svc
$ oc expose svc/holav2; oc get route
$ curl holav2-jack-tzdata.morgan-stanley-rhacer-clu-ecf58268eb10995f067698dffc82d2a7-0000.eu-gb.containers.appdomain.cloud
```
Advantages:  no need for local docker build environment.
Disadvantage: the image is stored in OpenShift and not available public.  It requires a further step to publish the image to a public registry, e.g. use skopeo copy, or export the 
