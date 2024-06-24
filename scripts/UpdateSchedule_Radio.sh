#!/bin/bash

DATA_FOLDER=~/data
SQL_FILES_FOLDER=~/files

if [ $DEV = "1" ];
then
	DATA_FOLDER=.
	SQL_FILES_FOLDER=.
fi


# Pull data files to be processed
~/scripts/UpdateSchedule_Radio_DownloadData.sh $DATA_FOLDER

# Load data files into database
~/scripts/UpdateSchedule_Radio_LoadDataIntoDB.sh $DATA_FOLDER $SQL_FILES_FOLDER
