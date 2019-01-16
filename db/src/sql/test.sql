select count(*) from "cameras.camera" where "CamType" = 'Speed Camera'

SELECT "CameraHeadRef", "SpeedLimitStd" 
 from "cameras.camera" where "CamType" = 'Speed Camera'
 
 
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
 
 
 
SELECT TO_TIMESTAMP(VDATE), VHOUR, VMIN, VSEC, add_seconds(TO_TIMESTAMP(VDATE),  3600 * VHOUR + 60 * VMIN + VSEC) AS EVENTTIMESTAMP
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
