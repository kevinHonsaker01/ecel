import glob
from pymongo import MongoClient
import os
import sys
from datetime import date
import base64
from itertools import islice
import zipfile

# Method never used ??
def chunks(data, size):
    it = iter(data)
    for i in xrange(0, len(data), SIZE):
        yield {k:data[k] for k in islice(it, SIZE)}


def pushDirectory(path, scenarioStore, count, data, scenName):
    
    # 10 MB size threshold before splitting 
    # of data is performed
    size = 10000

    # Recursively go through path for files to 
    # upload; stop recursive calls when files
    # instead of directories have been reached
    for name in os.listdir(path):
        
        print("Name: ", name)

        # change of absolute path
        absolutePath = path + '/' + name
        if(os.path.isdir(absolutePath)):
            print("\nAbsolute path is a directory: ", os.path.isdir(absolutePath))

            # Recursive call
            pushDirectory(absolutePath, scenarioStore, count, data, scenName)

        else:

            # If they are zipped, program should unzip and upload
            # Continue for now April 21, 2020
            if '.zip' in absolutePath:
                print("Encountered zipfile.")
            
            # Print contents to make sure file is not empty
            print("\t\tAbsolute Path: ", absolutePath) 
            
            # Opening the file in binary format for reading 'rb'
            with open(absolutePath, "rb") as image_file:

                # encoding the file in base64
                complete_file = image_file.read()
                encoded_img = base64.b64encode(complete_file)
                image_file.close()

            # MongoDB complains if periods are present (quick-fix)
            # At this point name is no longer a directory
            # It is the file (.txt, .zip, .pcap)
            name = name.replace('.',';')

            # Store file in dictionary that was passed
            # into the pushDirectory()
            scenarioStore[name] = encoded_img

            # Size check; file might be to big for the
            # BSON default of 16 MB
            if(sys.getsizeof(scenarioStore)>size):
                count+=1
                data.insert_one(scenarioStore)
                scenarioStore.clear()
                scenarioStore['name'] = scenName + "pt" + str(count)


def main():

    # Database client 
    client = MongoClient("mongodb+srv://BWR:benji@adventurermart-j760a.mongodb.net/test")
    db = client.Test

    # Database where files are sent
    data = db["Demo"]

    # Find zip files in ECEL_HOME/ecel_data folder
    path = os.environ['ECEL_HOME'] + '/ecel_data'

    today = date.today()
    today = today.strftime("%d%b%Y")
    scenName = str(today) + "_Scenario_"
    
    # count is for a massive file (bigger than 10 MB) to label in parts
    count = 1 

    # A dictionary to store ...
    scenarioStore = {"name": scenName}

    # Pushing all data in $ECEL_HOME/ecel_data folder
    print("Initiating push of: ", path)
    pushDirectory(path, scenarioStore, count, data, scenName)
    data.insert_one(scenarioStore)


if __name__ == '__main__':
    main()
