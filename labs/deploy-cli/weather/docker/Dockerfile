FROM registry.ocp4.example.com:8443/ubi8/python-39:latest

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py app.py

EXPOSE 8080

CMD ["gunicorn", "app", "--bind", ":8080"]
