import glob
from pymongo import MongoClient
import os
import sys
from datetime import date
import base64


def pushDirectory(path, scenarioStore):

    for name in os.listdir(path):
        absolutePath = path + '/' + name
        if(os.path.isdir(absolutePath)):
            pushDirectory(absolutePath, scenarioStore)
        else:
            with open(absolutePath, "rb") as image_file:
                encoded_img = base64.b64encode(image_file.read())
                print("pushing " + name)
            name = name.replace('.',';')
            scenarioStore[name] = encoded_img
            os.remove(absolutePath)

def main():

    client = MongoClient("mongodb+srv://BWR:benji@adventurermart-j760a.mongodb.net/test")
    db = client.Test
    data = db["Demo"]

    ##Change this to whatever the path is for you
    try:
        path = os.environ['ECEL_HOME']+'/ecel_data'
    except:
        print("Does not exist.")
        pass

    if os.path.exists(path):
        today = date.today()
        today = today.strftime("%d%b%Y")
        scenName = str(today) + "Scenario"
        encodedFile = ""

        scenarioStore = {"name": scenName}

        #might need the following line for ubuntu
        #files = glob.glob(path)

        absolutePath = ""
        print("beginning push")
        pushDirectory(path, scenarioStore)
        data.insert_one(scenarioStore)

    else:
        print("Path does not exist.")
        sys.exit(1)

if __name__ == '__main__':
    main()
