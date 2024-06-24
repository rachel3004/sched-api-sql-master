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


KIDS_CSV_URL='https://docs.google.com/spreadsheets/d/1GpdyPUbjETW3GHniZiiHVND3bCo7LoSr14fo9Ruq2ws/export?format=csv&id=1GpdyPUbjETW3GHniZiiHVND3bCo7LoSr14fo9Ruq2ws&gid=1281558892'

# Pull files from the Protrack Server (64.83.241.61)
scp -P 64226 websched@64.83.241.61:/u/guest_ftp/export/pg_air.txt $DATA_FOLDER
scp -P 64226 websched@64.83.241.61:/u/guest_ftp/export/pg_desc.txt $DATA_FOLDER
scp -P 64226 websched@64.83.241.61:/u/guest_ftp/export/pgmaster.txt $DATA_FOLDER

curl $KIDS_CSV_URL | grep -wv ',' | sed 's/\r$//' > $DATA_FOLDER/kids_stream_url.csv
