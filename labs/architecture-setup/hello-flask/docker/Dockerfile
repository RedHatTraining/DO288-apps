FROM registry.ocp4.example.com:8443/ubi8/python-39

# By default, listen on port 8081
EXPOSE 8081/tcp
ENV FLASK_PORT=8081

# Set the working directory in the container
WORKDIR /projects

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install any dependencies
RUN pip install -r requirements.txt

# Copy the content of the local src directory to the working directory
COPY src/ .

# Specify the command to run on container start
CMD [ "python", "-m", "gunicorn", "-b", "0.0.0.0:8081", "app:app" ]
