---- HIST
DROP VIEW V_HIST;
CREATE VIEW  V_HIST AS (
SELECT  "cameras.cameraAccidentHist"."CameraHeadRef", "Occurence" / sum("Occurence") OVER ()  AS FREQ 
FROM "cameras.cameraAccidentHist" 
INNER JOIN "cameras.camera"
ON "cameras.cameraAccidentHist"."CameraHeadRef" = "cameras.camera"."CameraHeadRef"
WHERE "Severity" <> 'Fatal' and "Severity" <> 'Serious' and "Severity" = 'Slight'
and "CamType" = 'Speed Camera' 
ORDER BY  "cameras.cameraAccidentHist"."CameraHeadRef"
	
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
CREATE VIEW  V_MAKE AS ( SELECT ROW_NUMBER() over () as "MAKESEQ", "MakeID" FROM "cameras.vehicleMake" );

SELECT * FROM V_MAKE;



----------------------------