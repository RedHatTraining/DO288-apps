from flask import Flask, redirect

application = Flask(__name__)


@application.route("/")
def index():
    return redirect("/tomorrow")


@application.route("/tomorrow")
def tomorrow():
    return day_weather("sunny", 5)


def day_weather(weather: str, rain_chance: int):
    return {"weather": weather, "rain_chance": f"{rain_chance}%"}


# Health checks


@application.route("/readyz")
def ready():
    return "Ok"


@application.route("/livez")
def alive():
    return "Ok"


if __name__ == "__main__":
    application.run()
