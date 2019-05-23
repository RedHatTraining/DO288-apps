s/^        listen       80/        listen       8080/
s/^user  nginx;//
s%/var/opt/rh/rh-nginx18/log/nginx/error.log%stderr%
s%access_log /var/opt/rh/rh-nginx18/log/nginx/access.log main;%%
