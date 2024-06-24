#!/bin/bash

if [ $# -ne 2 ]; 
then
  #echo $0: usage: DATA_FOLDER SQL_FILES_FOLDER
  #exit 1
  DATA_FOLDER=~/data
  SQL_FILES_FOLDER=~/files
else
  DATA_FOLDER=$1
  SQL_FILES_FOLDER=$2
fi

# echo DATA_FOLDER=$DATA_FOLDER

cd $DATA_FOLDER

echo "Processing TV data"
sudo mysql -uroot < $SQL_FILES_FOLDER/UpdateSchedule_TV_LoadDataIntoDB.sql
