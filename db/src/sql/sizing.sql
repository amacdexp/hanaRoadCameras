-- 1 hour ~ 28Mb
-- 2 hours ~ 51Mb
-- 3 hours ~ 77Mb
-- 4 hours ~ 108Mb
-- 5 hours ~ 133Mb
-- 6 hours ~ 156Mb
-- 7 hours ~ 182Mb
-- 8 hours ~ 206Mb
-- 9 hours ~ 233Mb
-- 9 hours ~ 261Mb

LOAD TESTCREATE ALL;

-- M_CS_TABLES (includes load status)
select --* 
	  SCHEMA_NAME
	, TABLE_NAME
	, LOADED
	, SUM(RECORD_COUNT) AS RECORD_COUNT
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024,2) AS MEMORY_SIZE_IN_KiB 
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024/1024,2) AS MEMORY_SIZE_IN_MiB 
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024/1024/1024,4) AS MEMORY_SIZE_IN_GiB 
from  M_CS_TABLES
where TABLE_NAME like '%TESTCREATE%'
group by
	  SCHEMA_NAME
	, TABLE_NAME
	, LOADED
order by
	  SCHEMA_NAME
	, TABLE_NAME
;
-- M_CS_ALL_COLUMNS (includes internal/hidden columns)
select 
	  SCHEMA_NAME
	, TABLE_NAME
	--, COLUMN_NAME
	, LOADED
	, 'N/A' AS RECORD_COUNT		-- not available in this view
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024,2) AS MEMORY_SIZE_IN_KiB 
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024/1024,2) AS MEMORY_SIZE_IN_MiB 
	, ROUND(SUM(MEMORY_SIZE_IN_TOTAL)/1024/1024/1024,4) AS MEMORY_SIZE_IN_GiB 
--select *
from M_CS_ALL_COLUMNS
where TABLE_NAME like '%TESTCREATE%'
group by
	  SCHEMA_NAME
	, TABLE_NAME
	--, COLUMN_NAME
	, LOADED
order by
	  SCHEMA_NAME
	, TABLE_NAME
	--, COLUMN_NAME
;




SELECT * FROM M_CS_UNLOADS;