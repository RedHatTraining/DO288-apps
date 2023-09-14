FROM registry.access.redhat.com/ubi8/nodejs-14 AS appbuild

LABEL version="1.0"
LABEL description="To Do List application builder"

# ENV REACT_APP_API_HOST=http://localhost:3000
ENV REACT_APP_API_HOST=""

USER 0

COPY . /tmp/todo-frontend

RUN cd /tmp/todo-frontend
RUN npm install
RUN npm run build

# https://github.com/sclorg/nginx-container
FROM registry.access.redhat.com/ubi8/nginx-118

LABEL version="1.0"
LABEL description="To Do List application front-end"
LABEL creationDate="2017-12-25"
LABEL updatedDate="2021-05-19"

COPY nginx.conf /etc/nginx/
COPY --from=appbuild /tmp/todo-frontend/build /usr/share/nginx/html

CMD nginx -g "daemon off;"
