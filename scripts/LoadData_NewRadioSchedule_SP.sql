USE pg;

DROP PROCEDURE IF EXISTS LoadData_NewRadioSchedule;
DELIMITER $$
CREATE PROCEDURE LoadData_NewRadioSchedule()
BEGIN

-- select all the non-empty rows into a temporary table, distinctly to remove duplicates
CREATE TEMPORARY TABLE IF NOT EXISTS 
  temp_NewRadioSchedulePrograms 
ENGINE=MyISAM 
AS (
  SELECT date, time, program_code, series, content, hosts, guests, program_number
  FROM NewRadioSchedulePrograms
  WHERE TRIM(date) <> ''
);

-- bring back the unique, distinct, non-empty rows
TRUNCATE TABLE NewRadioSchedulePrograms;
INSERT INTO NewRadioSchedulePrograms SELECT * FROM temp_NewRadioSchedulePrograms; 
DROP TEMPORARY TABLE temp_NewRadioSchedulePrograms;  

-- delete all the empty rows from the table
-- DELETE nrsp FROM NewRadioSchedulePrograms AS nrsp
-- WHERE TRIM(nrsp.date) = '';

/*
-- Concatenate the program_number and program_code in the first record when duplicates occur in the same time slot
-- NOTE: this would not handle the case where there were more than 2 duplicates
UPDATE NewRadioSchedulePrograms t1 
INNER JOIN NewRadioSchedulePrograms t2  
SET t1.program_code = CONCAT(t1.program_code,' & ',t2.program_code), 
    t1.program_number = CONCAT(t1.program_number,' & ',t2.program_number) 
WHERE t1.date = t2.date 
  AND t1.time = t2.time 
  AND t1.series = t2.series 
  AND t1.content = t2.content 
  AND t1.hosts = t2.hosts 
  AND t1.guests = t2.guests 
  AND (t1.program_code <> t2.program_code OR t1.program_number <> t2.program_number);

-- Delete additional records when duplicates occur in the same time slot
DELETE t1 FROM NewRadioSchedulePrograms t1 
INNER JOIN NewRadioSchedulePrograms t2 
WHERE t1.id > t2.id 
  AND t1.date = t2.date 
  AND t1.time = t2.time 
  AND t1.series = t2.series 
  AND t1.content = t2.content 
  AND t1.guests = t2.guests 
  AND (t1.program_code <> t2.program_code OR t1.program_number <> t2.program_number);
*/


-- Get the date first and last date in the new programs and delete all existing programs between those dates, prior to importing the new radio 
-- schedule programs

/* 2020-08-09: The decision was made to wipe out all program data from database and import only what is in the file.
SELECT STR_TO_DATE(date, '%m/%d/%Y') AS date
INTO @first_date
FROM NewRadioSchedulePrograms AS nrsp
ORDER BY date ASC
limit 1;

SELECT STR_TO_DATE(date, '%m/%d/%Y') AS date
INTO @last_date
FROM NewRadioSchedulePrograms AS nrsp
ORDER BY date DESC
limit 1;

DELETE FROM radio_data WHERE STR_TO_DATE(date, '%m/%d/%Y') BETWEEN @first_date AND @last_date;
-- SELECT COUNT(*) FROM radio_data WHERE STR_TO_DATE(date, '%m/%d/%Y') BETWEEN @first_date AND @last_date;
*/
TRUNCATE TABLE radio_data;


--
-- Now add the radio special override programs to the schedule
--

select @mid := COALESCE(MAX(id),0) from radio_data;

INSERT INTO radio_data (id, date, time, series, content, guests, program_code, program_number)
SELECT (@mid:=@mid + 1) AS num, date, time, series, content, 
       CONCAT(IF(TRIM(hosts)<>'',CONCAT(TRIM(hosts),', '),''),IF(TRIM(guests)<>'',CONCAT(', ',TRIM(guests)),'')) as guests, 
       program_code, program_number
FROM NewRadioSchedulePrograms;

-- SELECT  STR_TO_DATE(CONCAT(rd.date,' ',rd.time), '%m/%d/%Y %H:%i:%s') as begin_date, rd.date, rd.time, rd.series, rd.content FROM NewRadioSchedulePrograms AS rd WHERE STR_TO_DATE(rd.date, '%m/%d/%Y') BETWEEN '2020-02-13' AND '2020-02-15' AND HOUR(rd.time) >= 11 ORDER BY begin_date;
-- ROLLBACK;

END;
$$

DELIMITER ;