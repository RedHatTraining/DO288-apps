FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

# Application listens on this port
ENV PORT=8080
EXPOSE ${PORT}

# Copy the application source code
ADD . $HOME

# Install application dependencies and clean up
RUN npm ci --omit=dev && rm -rf .npm

# Fix permissions to write to /var/cache
USER root
RUN chgrp -R 0 /var/cache && \
    chmod -R g=u /var/cache
USER 1001

# Run the server
CMD npm start
