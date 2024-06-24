#!/bin/bash

if [ $# -ne 1 ]; 
then
  #echo $0: usage: DATA_FOLDER
  #exit 1
  DATA_FOLDER=~/data
else
  DATA_FOLDER=$1
fi

# echo DATA_FOLDER=$DATA_FOLDER


#RADIO_CSV_URL='https://docs.google.com/spreadsheets/d/18H6D3FCzs6tHbI7G04EyA-Z_qJwrUXhWVyhFg5L8Qj4/export?format=csv&id=18H6D3FCzs6tHbI7G04EyA-Z_qJwrUXhWVyhFg5L8Qj4&gid=851688896'

# MLR2019-08-09: use curl to pull the file, sed to remove empty rows, and nl to add line numbers
#curl $RADIO_CSV_URL | sed '/^\(,\|\s\)\{1,\}$/d' | nl -s ',' > $DATA_FOLDER/radio_data.csv

# Pull files from the Protrack Server (64.83.241.61)
scp -P 64226 websched@64.83.241.61:/u/guest_ftp/export/radio/radio_schedule.csv $DATA_FOLDER

