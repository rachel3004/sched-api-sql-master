SELECT
    distinct(SELECT IF ((DATE_FORMAT(STR_TO_DATE(pg_air.ai_air_strt_inst, '%Y-%m-%d %T'), '%w') LIKE 1 AND DATE_FORMAT(STR_TO_DATE(pg_air.ai_air_strt_inst, '%Y-%m-%d %T'), '%H:%i')), pgmaster.ser_lgtitl, '')) AS 'Monday',
    DATE_FORMAT(STR_TO_DATE(pg_air.ai_air_strt_inst, '%Y-%m-%d %T'), '%H:%i') AS 'time'
    
FROM
    pg_air
    RIGHT JOIN
		pgmaster ON pg_air.version_id = pgmaster.version_id
WHERE
    pg_air.ai_virt_chnl = '3ABN'
        AND (pg_air.ai_air_strt_inst LIKE '2018-11-11%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-12%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-13%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-14%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-15%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-16%'
        OR pg_air.ai_air_strt_inst LIKE '2018-11-17%'
        )