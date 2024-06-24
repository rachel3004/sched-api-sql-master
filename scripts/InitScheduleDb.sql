DROP DATABASE IF EXISTS pg;
DROP USER IF EXISTS sched@localhost;

CREATE DATABASE pg;
CREATE USER sched@localhost IDENTIFIED BY 'JGVbyVwRmf67nMJMDpKr';
GRANT ALL PRIVILEGES ON pg.* to sched@localhost;

USE pg;

CREATE TABLE pg_air (
	ai_serial integer PRIMARY KEY,
	version_id integer,
	series_id integer,
	ai_air_strt_inst char(25),
	ai_air_date char(10),
	ai_air_time time,
	ai_air_tsecs integer,
	ai_air_len char(11),
	ai_air_lsecs integer,
	ai_source char(10),
	ai_split char(1),
	ai_audio_src char(15),
	ai_video_src char(15),
	ai_rit_no integer,
	ai_rel_no integer,
	ai_notes char(30),
	ai_notes2 char(30),
	ai_virt_chnl char(10),
	ai_dtv_fmt char(10),
	ai_dtv_bwidth float,
	channel_sfx char(2),

	INDEX(ai_air_strt_inst, ai_virt_chnl, version_id)
);

CREATE TABLE pgmaster (
	version_id integer PRIMARY KEY,
	program_id integer,
	series_id integer,
	ser_title char(50),
	pg_title char(50),
	vsn_descript char(50),
	pg_number integer,
	vsn_numberc char(1),
	vsn_order smallint,
	vsn_total smallint,
	sea_season smallint,
	ser_type char(1),
	ser_is_nola char(1),
	ser_nola_base char(6),
	vsn_nola_code char(15),
	vsn_lsecs integer,
	vsn_is_approx char(1),
	ser_source char(5),
	ser_pgm_type char(15),
	pg_topic char(20),
	pg_topic_2 char(20),
	pg_sd2_code char(15),
	vsn_language char(15),
	vsn_caption char(6),
	vsn_stereo char(6),
	vsn_color char(1),
	pg_writeable char(10),
	vsn_rating char(5),
	vsn_subrating char(10),
	vsn_hdtv char(5),
	vsn_content char(1),
	vsn_letterbox char(10),
	vsn_as2 char(15),
	vsn_length char(11),
	ser_lgtitl char(120),
	pg_lgtitl char(120),
	pgm_obdate date,
	pgm_prod_loc char(20),
	pgm_year_prod char(4),
	pgm_pri_demog char(6),
	pgm_sched_notes char(140),
	stinv_cd char(30),
	ta_cd char(30),
	ccxmpt_cd char(30),
	inst_levl char(30),
	pg1_cd char(30),
	pg2_cd char(30),
	vsn_dubbed char(1),
	vsn_dub_lang char(3),
	vsn_subtitles char(1),
	vsn_sub_lang char(3),
	ser_itv_itm char(1),
	ser_uselnk char(1),
	ser_url text,
	pg_uselnk char(1),
	pg_url text,

	INDEX(version_id)
);

CREATE TABLE pg_desc (
	version_id integer,
	series_id integer,
	pgu_location char(15),
	pgu_text text,
	channel_sfx char(2),

	INDEX(version_id)
);

CREATE TABLE kids_stream_url (
	program_code char(15) PRIMARY KEY,
	url text,

	INDEX (program_code)
);

CREATE TABLE radio_data (
	id INT PRIMARY KEY,
	date char(15),
	time char(15),
	program_code char(30),
	series text,
	content text,
	guests text,
	program_number text,

	INDEX (date, time)
);

CREATE TABLE RadioSpecialsOverride (
	date char(15),
	time char(15),
	length_minutes float,
	program_code char(30),
	series text,
	content text,
	guests text,
	program_number text,

	INDEX (date, time)
);

CREATE TABLE NewRadioSchedulePrograms (
	date char(15),
	time char(15),
	program_code char(30),
	series text,
	content text,
	hosts text,
	guests text,
	program_number text,

	INDEX (date, time)
);

DROP PROCEDURE IF EXISTS getSched;
DELIMITER //
CREATE PROCEDURE pg.getSched (_channel TEXT, _date TEXT, _offset TEXT )
	BEGIN
		SELECT sub.* FROM (
			SELECT
			pg_air.version_id AS 'version_id',
			pgmaster.ser_lgtitl AS 'series_title',
			pgmaster.pg_lgtitl AS 'program_title',
			(SELECT CONCAT(pgmaster.ser_nola_base, SUBSTRING(pgmaster.vsn_nola_code, -6))) AS 'program_code',
			pgmaster.vsn_caption AS 'close_caption',
			pgmaster.vsn_rating AS 'rating',
			(SELECT pg_desc.pgu_text FROM pg_desc WHERE pg_desc.pgu_location = 'DESC' AND pg_desc.version_id = pg_air.version_id) AS 'description',
			(SELECT pg_desc.pgu_text FROM pg_desc WHERE pg_desc.pgu_location = 'GUEST' AND pg_desc.version_id = pg_air.version_id) AS 'guest',
			(SELECT pg_desc.pgu_text FROM pg_desc WHERE pg_desc.pgu_location = 'HOST' AND pg_desc.version_id = pg_air.version_id) AS 'host',
			(SELECT pg_desc.pgu_text FROM pg_desc WHERE pg_desc.pgu_location = 'SPEAKER' AND pg_desc.version_id = pg_air.version_id) AS 'speaker',
			(SELECT pg_desc.pgu_text FROM pg_desc WHERE pg_desc.pgu_location = 'MUSIC' AND pg_desc.version_id = pg_air.version_id) AS 'music',
			pg_air.ai_virt_chnl AS 'channel',
			pgmaster.vsn_length AS 'duartion',
			pgmaster.sea_season AS 'season',
			pgmaster.ser_url AS 'url',
			(SELECT CONCAT('https://s3.amazonaws.com/3abn-sched-images/', pgmaster.ser_nola_base, '.jpg')) AS series_img,
            (SELECT kids_stream_url.url FROM kids_stream_url WHERE kids_stream_url.program_code = (SELECT CONCAT(pgmaster.ser_nola_base, SUBSTRING(pgmaster.vsn_nola_code, -6)))) AS 'stream_url',
			(DATE_FORMAT(CONVERT_TZ(STR_TO_DATE(pg_air.ai_air_strt_inst, '%Y-%m-%d %T'), 'America/Chicago', _offset), (SELECT CONCAT('%Y-%m-%dT%T', _offset)) )) AS 'date'
        FROM pg_air
        LEFT JOIN pgmaster ON pg_air.version_id = pgmaster.version_id
        WHERE pg_air.ai_virt_chnl = _channel
        AND (
            pg_air.ai_air_strt_inst LIKE (SELECT CONCAT(_date, '%'))
            OR pg_air.ai_air_strt_inst LIKE (SELECT CONCAT( (SELECT DATE_ADD(_date, INTERVAL -1 DAY)) , '%'))
            OR pg_air.ai_air_strt_inst LIKE (SELECT CONCAT( (SELECT DATE_ADD(_date, INTERVAL 1 DAY)) , '%')) )
            
            ) sub
            WHERE date LIKE (SELECT CONCAT(_date, '%'))
            ORDER BY date;
 END;
 //

 DELIMITER ;
 

DROP PROCEDURE IF EXISTS getRadio;
DELIMITER //
CREATE PROCEDURE pg.getRadio (_date TEXT, _offset TEXT )
	BEGIN
		SELECT sub.* FROM (
			SELECT
			series AS 'series_title',
			content AS 'program_title',
			program_code,
			(SELECT CONCAT('https://s3.amazonaws.com/3abn-sched-images/', program_code, '.jpg')) AS series_img,
			(DATE_FORMAT(CONVERT_TZ(STR_TO_DATE(CONCAT(date, time), '%m/%d/%Y%T'), 'America/Chicago', _offset), (SELECT CONCAT('%Y-%m-%dT%T', _offset)) )) AS 'date',
      guests AS 'guest'      
        FROM radio_data
            ) sub
            WHERE date LIKE (SELECT CONCAT(_date, '%'))
            ORDER BY date;
 END;
 //

 DELIMITER ;