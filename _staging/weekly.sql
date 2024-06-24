SELECT 
    (DATE_FORMAT(CONVERT_TZ(STR_TO_DATE(pg_air.ai_air_strt_inst, '%Y-%m-%d %T'),
                    'America/Chicago',
                    '-06:00'),
            '%w-%H:%i')) AS 'time',
    pg_air.version_id AS 'version_id',
    pgmaster.ser_nola_base AS 'series_code',
    pgmaster.ser_lgtitl AS 'series_title',
    pg_air.ai_virt_chnl AS 'channel',
    pgmaster.vsn_length AS 'duartion',
    pgmaster.pg_url AS 'url',
    (SELECT 
            CONCAT('https://s3.amazonaws.com/3abn-sched-images/',
                        pgmaster.ser_nola_base,
                        '.jpg')
        ) AS series_img
FROM
    pg_air
        LEFT JOIN
    pgmaster ON pg_air.version_id = pgmaster.version_id
WHERE
    pg_air.ai_virt_chnl = '3ABN'
        AND (pg_air.ai_air_strt_inst LIKE (SELECT CONCAT('2018-11-11', '%'))
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 1 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 2 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 3 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 3 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 4 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 5 DAY)),
                        '%')
        )
        OR pg_air.ai_air_strt_inst LIKE (SELECT 
            CONCAT((SELECT DATE_ADD('2018-11-11', INTERVAL 6 DAY)),
                        '%')
        ))

