from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/livez")
def livez():
    return "OK"


@app.route("/readyz")
def readyz():
    return "OK"


if __name__ == "__main__":
    app.run(port=8080, host="0.0.0.0")
