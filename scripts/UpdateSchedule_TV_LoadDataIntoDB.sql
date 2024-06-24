USE pg;

DELETE FROM pg_air;
DELETE FROM pgmaster;
DELETE FROM pg_desc;
DELETE FROM kids_stream_url;

LOAD DATA LOCAL INFILE "pg_air.txt" INTO TABLE pg_air CHARACTER SET 'utf8' FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE "pgmaster.txt" INTO TABLE pgmaster CHARACTER SET 'utf8' FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE "pg_desc.txt" INTO TABLE pg_desc CHARACTER SET 'utf8' FIELDS TERMINATED BY '|';

LOAD DATA LOCAL INFILE "kids_stream_url.csv" INTO TABLE kids_stream_url CHARACTER SET 'utf8' FIELDS TERMINATED BY ',';
