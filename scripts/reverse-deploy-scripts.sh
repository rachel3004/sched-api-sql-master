#!/bin/bash

set -x

# change directory to the directory of this script
cd "${0%/*}"

FILES_FOLDER=../../../files
SCRIPTS_FOLDER=../../../scripts
printf "\n";

cp $FILES_FOLDER/InitScheduleDb.sql ./;
cp $FILES_FOLDER/LoadData_NewRadioSchedule_SP.sql ./;
cp $FILES_FOLDER/UpdateSchedule_Radio_LoadDataIntoDB.sql ./;
cp $FILES_FOLDER/UpdateSchedule_TV_LoadDataIntoDB.sql ./;
printf "\n";

cp $SCRIPTS_FOLDER/UpdateSchedule_Radio.sh ./;
cp $SCRIPTS_FOLDER/UpdateSchedule_Radio_DownloadData.sh ./;
cp $SCRIPTS_FOLDER/UpdateSchedule_Radio_LoadDataIntoDB.sh ./;
cp $SCRIPTS_FOLDER/UpdateSchedule_TV.sh ./;
cp $SCRIPTS_FOLDER/UpdateSchedule_TV_DownloadData.sh ./;
cp $SCRIPTS_FOLDER/UpdateSchedule_TV_LoadDataIntoDB.sh ./;
