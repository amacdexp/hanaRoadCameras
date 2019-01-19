select count(*) from "cameras.camera" where "CamType" = 'Speed Camera'

SELECT "CameraHeadRef", "SpeedLimitStd" 
 from "cameras.camera" where "CamType" = 'Speed Camera'

SELECT *
FROM "cameras.vehicleColor","cameras.vehicleMake","cameras.vehicleType"

SELECT --* 
      MIN(ZZ), MAX(ZZ), MIN(FREQ), MAX(FREQ) FROM (
SELECT ZZ , FREQ, CASE WHEN ZZ < FREQ THEN round(RAND()*30,0) ELSE RAND()*-10 END as DELTA, SPEED
from (
SELECT * , "Occurence" / sum("Occurence") OVER ()  AS FREQ , RAND() AS ZZ, 60 as SPEED
FROM "cameras.cameraAccidentHist" WHERE "Severity" <> 'Fatal' and "Severity" <> 'Serious' and "Severity" = 'Slight'
)
)
--WHERE DELTA > 0
;


---- HIST
DROP VIEW V_HIST;
CREATE VIEW  V_HIST AS (
SELECT  "CameraHeadRef", "Occurence" / sum("Occurence") OVER ()  AS FREQ 
FROM "cameras.cameraAccidentHist" WHERE "Severity" <> 'Fatal' and "Severity" <> 'Serious' and "Severity" = 'Slight'
ORDER BY "CameraHeadRef"
	
)
;

SELECT * FROM V_HIST;


------  COLOR
DROP VIEW V_COLOR;
CREATE VIEW  V_COLOR AS (
SELECT SEQ as COLORSEQ, "ColorID" FROM (	
SELECT DISTINCT * FROM 
(SELECT TOP 1000 round(RAND(),2) as SEQ FROM OBJECTS ),
(
SELECT "ROWNUM", "ColorID", FREQ, SUM(FREQ) OVER (  ORDER BY "ROWNUM" ) AS FREQSEQ
FROM (
SELECT * FROM ( SELECT ROW_NUMBER() over () as "ROWNUM", "ColorID", round("OccurenceAvg" / sum("OccurenceAvg") OVER () , 2)   as FREQ
from "cameras.vehicleColor" ) WHERE FREQ > 0)
) 
WHERE ( SEQ > (FREQSEQ - FREQ)  ) -- OR  ( SEQ = 0 AND FREQ = 0) )
and   SEQ <= FREQSEQ
ORDER BY "ROWNUM", "ColorID", "FREQSEQ"
)
ORDER BY SEQ
)
;

SELECT * FROM V_COLOR;

------  TYPE
DROP VIEW V_TYPE;
CREATE VIEW  V_TYPE AS (
SELECT SEQ as TYPESEQ, "TypeID" FROM (	
SELECT DISTINCT * FROM 
(SELECT TOP 100000 round(RAND(),4) as SEQ FROM OBJECTS, objects ),
(
SELECT "ROWNUM", "TypeID", FREQ, SUM(FREQ) OVER (  ORDER BY "ROWNUM" ) AS FREQSEQ
FROM (
SELECT * FROM ( SELECT ROW_NUMBER() over () as "ROWNUM", "TypeID", round("OccurenceAvg" / sum("OccurenceAvg") OVER () , 4)   as FREQ
from "cameras.vehicleType" )  WHERE FREQ > 0)
) 
WHERE ( SEQ > (FREQSEQ - FREQ)  ) -- OR  ( SEQ = 0 AND FREQ = 0) )
and   SEQ <= FREQSEQ
ORDER BY "ROWNUM", "TypeID", "FREQSEQ"
)
ORDER BY SEQ
)
;

SELECT * FROM V_TYPE;
SELECT count(*) FROM V_TYPE;


------  MAKE
DROP VIEW V_MAKE;
CREATE VIEW  V_MAKE AS (
SELECT SEQ as MAKESEQ, "MakeID" FROM (	
SELECT DISTINCT * FROM 
(SELECT TOP 1000 round(RAND(),2) as SEQ FROM OBJECTS ),
(
SELECT "ROWNUM", "MakeID", FREQ, SUM(FREQ) OVER (  ORDER BY "ROWNUM" ) AS FREQSEQ
FROM (
SELECT * FROM ( SELECT ROW_NUMBER() over () as "ROWNUM", "MakeID", round("CNT" / sum("CNT") OVER () , 2)   as FREQ
from ( SELECT * , 1 as "CNT" FROM "cameras.vehicleMake" ) ) WHERE FREQ > 0)
) 
WHERE ( SEQ > (FREQSEQ - FREQ)  ) -- OR  ( SEQ = 0 AND FREQ = 0) )
and   SEQ <= FREQSEQ
ORDER BY "ROWNUM", "MakeID", "FREQSEQ"
)
ORDER BY SEQ
)
;

DROP VIEW V_MAKE;
CREATE VIEW  V_MAKE AS ( SELECT ROW_NUMBER() over () as "SEQ", "MakeID" FROM "cameras.vehicleMake" );

SELECT * FROM V_MAKE;
SELECT COUNT(*) FROM "cameras.vehicleMake";
SELECT distinct ROUND(RAND()*76,0) FROM OBJECTS;

------------------


 SELECT 'ABCD_____'  || to_char(round(RAND()*50000000,0)) || '_XYZ' as "CHAR_COLKEY"  FROM DUMMY;
 
 SELECT DISTINCT A FROM (
 SELECT CHAR(65 + round(rand() * 25,0)) AS A from OBJECTS   limit 10000)
 order by A;
 
 --YEAR
 SELECT  DISTINCT V AS VYEAR FROM (
  SELECT TO_CHAR(2019 + round(rand() * 0,0)) AS V from OBJECTS   limit 10000)
 order by V;
 
  --MONTH
 SELECT  DISTINCT V AS VMONTH FROM (
  SELECT LPAD(TO_CHAR(01 + round(rand() * 0,0)),2,'0') AS V from OBJECTS   limit 10000)
 order by V;
 
 --DATE
 SELECT  DISTINCT V AS VDATE FROM (
  SELECT ADD_DAYS('2019-01-01', round(Rand() * 0 * 0 * 0, 0)) AS V from OBJECTS   limit 10000)
WHERE V <= '2026-01-01'  
 order by V;

-- DAYHOURS
SELECT MIN(VTIME), MAX(VTIME), COUNT(*)
SELECT HOUR(VTIME)
from (
SELECT  DISTINCT V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), 3600 * round(rand()*23,0) ) AS V from OBJECTS  limit 5000)
-- order by V
 order by V
 )
 ;
 
-- IN HOUR 5000
--select count(*) 
SELECT MIN(VTIME), MAX(VTIME), COUNT(*)
SELECT MINUTE(VTIME), SECOND(VTIME)
from (
SELECT  top 5000 V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), round(rand()*59*60,0) ) AS V from OBJECTS, OBJECTS   limit 50000)
-- order by V
 );
 
 
 
 
------------------ MAIN GEN SQL
SELECT "CameraHeadRef", EVENTTIMESTAMP,  VNP , "SpeedLimitStd" as "SpeedLimit", "SpeedDelta", "SpeedLimitStd" + "SpeedDelta" as "Speed",  COLORRAND,TYPERAND,MAKERAND FROM (
SELECT "CameraHeadRef", EVENTTIMESTAMP,  VNP , "SpeedLimitStd",  CASE WHEN SPEEDRAND < "HISTFREQ" THEN round(RAND()*30,0) ELSE ROUND(RAND()*-10,0) END as "SpeedDelta" 
       ,COLORRAND,TYPERAND,MAKERAND
    FROM ( 

SELECT "CameraHeadRef", EVENTTIMESTAMP,  VNP , "SpeedLimitStd", "HISTFREQ", RAND() as SPEEDRAND , 
       ROUND(RAND(),2) as COLORRAND, ROUND(RAND(),4) as TYPERAND, ROUND(RAND()*76,0) as MAKERAND --, 'Light Vehicle' as "VTYPE"

FROM (
SELECT TO_TIMESTAMP(VDATE), VHOUR, VMIN, VSEC, add_seconds(TO_TIMESTAMP(VDATE),  3600 * VHOUR + 60 * VMIN + VSEC) AS EVENTTIMESTAMP,
     CHAR(65 + round(rand() * 25,0)) || CHAR(65 + round(rand() * 25,0)) || SUBSTRING (LPAD(TO_CHAR(round(rand() * 100,0)),2,'0'),0,2) || ' ' || CHAR(65 + round(rand() * 25,0)) || CHAR(65 + round(rand() * 25,0)) || CHAR(65 + round(rand() * 25,0))  AS VNP
FROM 
-- DATE	
(
 SELECT  DISTINCT V AS VDATE FROM (
  SELECT ADD_DAYS('2019-01-01', round(Rand() * 0 * 0 * 0, 0)) AS V from OBJECTS   limit 10000)
WHERE V <= '2026-01-01'  
 order by V),
(
SELECT HOUR(VTIME) as VHOUR
from (
---  HOURS	  24 = rand()*23
SELECT  DISTINCT V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), 3600 * round(rand()*0,0) ) AS V from OBJECTS  limit 5000)
-- order by V
 order by V
 )
) ,
(
-- 1 HOUR GEN
SELECT MINUTE(VTIME) AS VMIN, SECOND(VTIME) as VSEC
from (
SELECT  top 5000 V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), round(rand()*59*60,0) ) AS V from OBJECTS, OBJECTS   limit 50000)
-- order by V
 )
)  

order by VDATE, VHOUR, VMIN, VSEC
) AS PARTA,
( SELECT TOP 500 "cameras.camera"."CameraHeadRef", "SpeedLimitStd" , FREQ as "HISTFREQ"
 from "cameras.camera" 
 INNER JOIN V_HIST
 ON "cameras.camera"."CameraHeadRef" = V_HIST."CameraHeadRef"
 where "CamType" = 'Speed Camera' 
) AS CAM 
)
)



-------------- NICE RANDOM
 
 SELECT USER_NAME, RRID , PARTB.* FROM 
 (
 SELECT USER_NAME, RIDMIN, RIDMAX , ROUND(RAND() * (RIDMAX - RIDMIN),0) + RIDMIN AS RRID   FROM USERS,
 (
 SELECT 
 	(SELECT MIN(RECORD_ID( "cameras.camera")) FROM "cameras.camera" ) AS RIDMIN ,
 	(SELECT MAX(RECORD_ID( "cameras.camera")) FROM "cameras.camera" ) AS RIDMAX
 	FROM DUMMY
 )
 ) AS PARTA,
 (
  SELECT RECORD_ID( "cameras.camera") as RID, * FROM "cameras.camera"  where "CamType" = 'Speed Camera' 
 ORDER BY RECORD_ID( "cameras.camera") ) AS PARTB
 WHERE PARTA.RRID = PARTB.RID


