USE pg;

#DELETE FROM NewRadioSchedulePrograms;
TRUNCATE TABLE NewRadioSchedulePrograms;

LOAD DATA LOCAL INFILE "radio_schedule.csv" INTO TABLE NewRadioSchedulePrograms CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

CALL LoadData_NewRadioSchedule;
