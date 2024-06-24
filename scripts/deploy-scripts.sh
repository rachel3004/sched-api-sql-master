#!/bin/bash

set -x

# change directory to the directory of this script
cd "${0%/*}"

FILES_FOLDER=../../../files
SCRIPTS_FOLDER=../../../scripts
printf "\n";

cp InitScheduleDb.sql $FILES_FOLDER/;
cp LoadData_NewRadioSchedule_SP.sql $FILES_FOLDER/;
cp UpdateSchedule_Radio_LoadDataIntoDB.sql $FILES_FOLDER/;
cp UpdateSchedule_TV_LoadDataIntoDB.sql $FILES_FOLDER/;
printf "\n";

cp UpdateSchedule_Radio.sh $SCRIPTS_FOLDER/;
cp UpdateSchedule_Radio_DownloadData.sh $SCRIPTS_FOLDER/;
cp UpdateSchedule_Radio_LoadDataIntoDB.sh $SCRIPTS_FOLDER/;
cp UpdateSchedule_TV.sh $SCRIPTS_FOLDER/;
cp UpdateSchedule_TV_DownloadData.sh $SCRIPTS_FOLDER/;
cp UpdateSchedule_TV_LoadDataIntoDB.sh $SCRIPTS_FOLDER/;
