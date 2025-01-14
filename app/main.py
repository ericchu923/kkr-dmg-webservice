import asyncio

from flask import Flask

from hypercorn.asyncio import serve
from hypercorn.config import Config

config = Config()
config.bind = ["0.0.0.0:80"]

app = Flask(__name__)

@app.route("/")
def getAllData():
    return "ALL"

@app.route("/api/member/create")
def addDamage():
    return "Create user"

@app.route("/api/member/update")
def updateDamage():
    return "Update user"

@app.route("/api/member/delete")
def deleteDamage():
    return "Delete"

if __name__ == "__main__":
    asyncio.run(serve(app, config))