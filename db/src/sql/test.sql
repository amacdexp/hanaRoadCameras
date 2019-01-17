select count(*) from "cameras.camera" where "CamType" = 'Speed Camera'

SELECT "CameraHeadRef", "SpeedLimitStd" 
 from "cameras.camera" where "CamType" = 'Speed Camera'



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
(SELECT TOP 1000000 round(RAND(),4) as SEQ FROM OBJECTS ),
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
 
 
 
 
 -----------------------
 
 
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
SELECT  DISTINCT V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), 3600 * round(rand()*23,0) ) AS V from OBJECTS  limit 5000)
-- order by V
 order by V
 )
) ,
(
SELECT MINUTE(VTIME) AS VMIN, SECOND(VTIME) as VSEC
from (
SELECT  top 5000 V AS VTIME FROM (
SELECT ADD_SECONDS (TO_TIMESTAMP ('2019-01-01 00:00:00'), round(rand()*59*60,0) ) AS V from OBJECTS, OBJECTS   limit 50000)
-- order by V
 )
)

order by VDATE, VHOUR, VMIN, VSEC


