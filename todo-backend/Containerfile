# https://github.com/sclorg/s2i-nodejs-container
FROM registry.access.redhat.com/ubi8/nodejs-14

LABEL version="1.0"
LABEL description="To Do List application backend"
LABEL creationDate="2017-12-25"
LABEL updatedDate="2021-05-19"

USER 0

COPY . /opt/app-root/src

RUN cd /opt/app-root/src && \
    npm install && \
    npm run build

ENV DATABASE_SVC=192.168.0.10
ENV DATABASE_PORT=3306
ENV DATABASE_PASSWORD=secret-pass
ENV PORT=3000

EXPOSE 3000

USER 1001

CMD npm start
