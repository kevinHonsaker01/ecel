#!/usr/bin/env bash
xmlFilePath="$1"
outputFilePath="$2"

for xmlFile in ${xmlFilePath}/*.xml; do
  outputFile=${outputFilePath}/$(echo `basename ${xmlFile}`| cut -f 1 -d '.').JSON
  java -jar /root/Practicum/ecel/plugins/parsers/nmap/XMLToJSON.jar ${xmlFile} $outputFile
done

