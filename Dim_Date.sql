{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 CREATE OR REPLACE TABLE MTL_DEV_DB.MTL_GOLD.DIM_DATE(\
    DATE_ID NUMBER(38, 0),\
    DATE TIMESTAMP_NTZ(9),\
    FULLDATE VARCHAR(50),\
    DAY_OF_MONTH NUMBER(38, 0),\
    DAYNAME VARCHAR(10),\
    DAY_OF_WEEK VARCHAR(9),\
    YEAR VARCHAR(4),\
    MONTH NUMBER(38, 0),\
    MONTH_NAME VARCHAR(3),\
    WEEK_OF_YEAR NUMBER(38, 0),\
    DAY_OF_YEAR NUMBER(38, 0),\
    QUARTER VARCHAR(1),\
    MONTHYEAR VARCHAR(10),\
    MMYYYY VARCHAR(6),\
    YYYYMM VARCHAR(6),\
    LASTDAYOFMONTH VARCHAR(10),\
    LASTDAYOFYEAR VARCHAR(10),\
    LASTDAYOFQUARTER VARCHAR(10),\
    YEARNAME VARCHAR(10),\
    FIRSTDAYOFMONTH VARCHAR(10),\
    FIRSTDAYOFQUATER VARCHAR(10),\
    FIRSTDAYOFYEAR VARCHAR(10),\
    MONTHOFQUARTER VARCHAR(10)\
); \
\
INSERT INTO MTL_DEV_DB.MTL_GOLD.DIM_DATE\
WITH DateRange AS (\
    SELECT TO_DATE('2010-01-01 00:00:00') AS date_value\
    UNION ALL\
    SELECT dateadd(day, 1, date_value)\
    FROM DateRange\
    WHERE dateadd(day, 1, date_value)<=TO_DATE('2030-12-31 23:59:59')\
)\
SELECT \
TO_NUMBER(TO_CHAR(date_value, 'YYYYMMDD')) AS DATE_ID,\
TO_TIMESTAMP(date_value) AS DATE,\
date_value AS FULLDATE,\
DAYOFMONTH(date_value) AS DAY_OF_MONTH,\
DAYNAME(date_value) AS DAYNAME,\
DAYOFWEEK(date_value) AS DAY_OF_WEEK,\
YEAR(date_value) AS YEAR,\
MONTH(date_value) AS MONTH,\
MONTHNAME(date_value) AS MONTH_NAME,\
WEEKOFYEAR(date_value) AS WEEK_OF_YEAR,\
DAYOFYEAR(date_value) AS DAY_OF_YEAR,\
QUARTER(date_value) AS QUARTER,\
TO_CHAR(date_value, 'MonYY') AS MONTHYEAR,\
TO_CHAR(date_value, 'MMYYYY') AS MMYYYY,\
TO_CHAR(date_value, 'YYYYMM') AS YYYYMM,\
LAST_DAY(date_value) AS LASTDAYOFMONTH,\
LAST_DAY(date_value,'year') AS LASTDAYOFYEAR,\
LAST_DAY(date_value,'quarter') AS LASTDAYOFQUARTER,\
CONCAT('CY ',YEAR) AS YEARNAME,\
DATE_TRUNC('MONTH', date_value) AS FIRSTDAYOFMONTH,\
DATE_TRUNC('QUARTER', date_value) AS FIRSTDAYOFQUARTER,\
DATE_TRUNC('YEAR', date_value) AS FIRSTDAYOFYEAR,\
MOD(EXTRACT(MONTH FROM date_value) - 1, 3) + 1 AS MONTHOFQUARTER\
FROM DateRange;\
\
SELECT * FROM MTL_DEV_DB.MTL_GOLD.DIM_DATE;\
\
TRUNCATE TABLE MTL_DEV_DB.MTL_GOLD.DIM_DATE;\
\
/*EXTRACT(MONTH FROM your_date): This extracts the month component from the date. For example, if your_date is in February, this part would return 2.\
\
- 1: We subtract 1 to adjust the month range to start from 0. This is done because we want to map January to 0, February to 1, March to 2, and so on.\
\
MOD(..., 3): The MOD function (modulo) calculates the remainder when the first argument is divided by the second argument. In this case, we divide the result of the previous step by 3. This gives us a value in the range of 0 to 2.\
\
+ 1: We add 1 to the result from the MOD operation. This ensures that the final result is in the range of 1 to 3, representing the month of the quarter.\
\
Putting it all together, this expression maps the months to the corresponding month within a quarter. For example:\
\
January (1) maps to Month of Quarter 1,\
February (2) maps to Month of Quarter 2,\
March (3) maps to Month of Quarter 3,\
April (4) maps to Month of Quarter 1 again, and so on.\
This allows you to categorize months based on their position within a quarter.*/\
}