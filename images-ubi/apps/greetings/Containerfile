FROM registry.ocp4.example.com:8443/ubi9/nodejs-18-minimal:1-51

ENV PORT=80
EXPOSE ${PORT}

USER root

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

CMD npm start
