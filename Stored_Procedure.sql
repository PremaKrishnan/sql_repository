{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 ----------------FULL LOAD----------------------------\
create or replace procedure employee_full()\
returns varchar\
language javascript\
as\
$$\
var command = `insert into dim_employee(\
emp_no,emp_type,emp_name,email,phone_number,salary,address,gender,dob,hire_date,start_date,\
active_flag) \
SELECT\
emp_no,\
emp_type,\
emp_name,\
email,\
phone_number,\
salary,\
address,\
gender,\
dob,\
hire_date,\
current_timestamp(),\
1 as active_flag  -- Set active_flag to 1\
FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE`;\
var cmd_dict = \{sqlText:command\};\
var stmt = snowflake.createStatement(cmd_dict);\
var rs = stmt.execute();\
return 'success';\
$$;\
\
CALL employee_full();\
\
-----------SELECT SILVER TABLE------------------------------\
SELECT * FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
\
---------SELECT GOLD----------\
SELECT * FROM MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
\
---------------SCD1-----------------------\
create or replace procedure employee_scd1()\
returns varchar\
language javascript\
as\
$$\
var command = `merge into dim_employee target\
USING(\
SELECT\
emp_no,\
emp_type,\
emp_name,\
email,\
phone_number,\
salary,\
address,\
gender,\
dob,\
hire_date\
FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE) AS source\
ON source.EMP_NO=target.EMP_NO \
when matched                        -- UPDATE condition       \
    then update \
    set target.EMP_NO = source.EMP_NO,\
    target.EMP_TYPE = source.EMP_TYPE,\
    target.EMP_NAME = source.EMP_NAME,\
    target.EMAIL = source.EMAIL,\
    target.PHONE_NUMBER = source.PHONE_NUMBER,\
    target.SALARY = source.SALARY,\
    target.ADDRESS = source.ADDRESS,\
    target.GENDER = source.GENDER,\
    target.DOB = source.DOB,\
    target.HIRE_DATE = source.HIRE_DATE\
when not matched \
    then insert     (EMP_NO,EMP_TYPE,EMP_NAME,EMAIL,PHONE_NUMBER,SALARY,ADDRESS,GENDER,DOB,HIRE_DATE,START_DATE,\
ACTIVE_FLAG)\
    values\
(source.EMP_NO,source.EMP_TYPE,source.EMP_NAME,source.EMAIL,source.PHONE_NUMBER,source.SALARY,source.ADDRESS,source.GENDER,source.DOB,source.HIRE_DATE,current_timestamp(),1)`;\
var cmd_dict = \{sqlText:command\};\
var stmt = snowflake.createStatement(cmd_dict);\
var rs = stmt.execute();\
return 'success';\
$$;\
\
CALL employee_scd1();\
\
--------SELECT BRONZE TABLE-----------------------\
SELECT * FROM MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE;\
\
-----------SELECT SILVER TABLE------------------------------\
SELECT * FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
\
---------SELECT GOLD----------\
SELECT * FROM MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
\
---------------SCD2-----------------------\
create or replace procedure employee_scd2()\
returns varchar\
language javascript\
as\
$$\
var command1 = `merge into dim_employee target\
USING(\
SELECT\
emp_no,\
emp_type,\
emp_name,\
email,\
phone_number,\
salary,\
address,\
gender,\
dob,\
hire_date\
FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE) AS source\
ON source.EMP_NO=target.EMP_NO\
WHEN MATCHED AND \
  (\
    target.EMP_TYPE != source.EMP_TYPE OR\
    target.EMP_NAME != source.EMP_NAME OR\
    target.EMAIL != source.EMAIL OR\
    target.PHONE_NUMBER != source.PHONE_NUMBER OR\
    target.SALARY != source.SALARY OR\
    target.ADDRESS != source.ADDRESS OR\
    target.GENDER != source.GENDER OR\
    target.DOB != source.DOB OR\
    target.HIRE_DATE != source.HIRE_DATE\
  )\
THEN\
  UPDATE SET\
    target.ACTIVE_FLAG = 0,\
    target.END_DATE = current_timestamp()`;\
    \
var command2 = `merge into dim_employee target\
USING(\
SELECT\
emp_no,\
emp_type,\
emp_name,\
email,\
phone_number,\
salary,\
address,\
gender,\
dob,\
hire_date\
FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE) AS source\
ON hash(source.EMP_NO,source.EMP_TYPE,source.EMP_NAME,source.EMAIL,source.PHONE_NUMBER,source.SALARY,source.ADDRESS,source.GENDER,source.DOB,source.HIRE_DATE)=hash(target.EMP_NO,target.EMP_TYPE,target.EMP_NAME,target.EMAIL,target.PHONE_NUMBER,target.SALARY,target.ADDRESS,target.GENDER,target.DOB,target.HIRE_DATE)\
when not matched \
    then insert(EMP_NO,EMP_TYPE,EMP_NAME,EMAIL,PHONE_NUMBER,SALARY,ADDRESS,GENDER,DOB,HIRE_DATE,START_DATE,\
ACTIVE_FLAG)\
    values\
(source.EMP_NO,source.EMP_TYPE,source.EMP_NAME,source.EMAIL,source.PHONE_NUMBER,source.SALARY,source.ADDRESS,source.GENDER,source.DOB,source.HIRE_DATE,current_timestamp(),1)`;\
\
// Create Statement objects for each command\
var stmt1 = snowflake.createStatement(\{ sqlText: command1 \});\
var stmt2 = snowflake.createStatement(\{ sqlText: command2 \});\
\
// Execute the SQL commands\
stmt1.execute();\
stmt2.execute();\
\
return 'success';\
$$;\
\
CALL employee_scd2();\
\
-----------SELECT SILVER TABLE------------------------------\
SELECT * FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
\
---------SELECT GOLD----------\
SELECT * FROM MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
\
---------------SCD2-----------------------\
create or replace procedure employee_scd2()\
returns varchar\
language javascript\
as\
$$\
var command = `merge into MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE AS target\
USING(\
       SELECT source.EMP_NO as JOIN_KEY, source.* FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE AS source\
       UNION ALL\
       SELECT NULL, source.* FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE AS source\
       INNER JOIN MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE AS target \
       ON target.EMP_NO = source.EMP_NO\
       WHERE (\
                target.EMP_TYPE != source.EMP_TYPE OR\
                target.EMP_NAME != source.EMP_NAME OR\
                target.EMAIL != source.EMAIL OR\
                target.PHONE_NUMBER != source.PHONE_NUMBER OR\
                target.SALARY != source.SALARY OR\
                target.ADDRESS != source.ADDRESS OR\
                target.GENDER != source.GENDER OR\
                target.DOB != source.DOB OR\
                target.HIRE_DATE != source.HIRE_DATE \
            ) AND target.END_DATE IS NULL\
    ) AS dataset\
ON dataset.JOIN_KEY = target.EMP_NO\
WHEN MATCHED AND \
  (\
    target.EMP_TYPE != dataset.EMP_TYPE OR\
    target.EMP_NAME != dataset.EMP_NAME OR\
    target.EMAIL != dataset.EMAIL OR\
    target.PHONE_NUMBER != dataset.PHONE_NUMBER OR\
    target.SALARY != dataset.SALARY OR\
    target.ADDRESS != dataset.ADDRESS OR\
    target.GENDER != dataset.GENDER OR\
    target.DOB != dataset.DOB OR\
    target.HIRE_DATE != dataset.HIRE_DATE\
  )AND target.END_DATE IS NULL\
THEN\
  UPDATE SET\
    target.ACTIVE_FLAG = 0,\
    target.END_DATE = current_timestamp()\
WHEN NOT MATCHED \
THEN\
INSERT(EMP_NO,EMP_TYPE,EMP_NAME,EMAIL,PHONE_NUMBER,SALARY,ADDRESS,GENDER,DOB,HIRE_DATE,START_DATE,\
ACTIVE_FLAG)\
    values\
(dataset.EMP_NO,dataset.EMP_TYPE,dataset.EMP_NAME,dataset.EMAIL,dataset.PHONE_NUMBER,dataset.SALARY,dataset.ADDRESS,dataset.GENDER,dataset.DOB,dataset.HIRE_DATE,current_timestamp(),1)`;\
var cmd_dict = \{sqlText:command\};\
var stmt = snowflake.createStatement(cmd_dict);\
var rs = stmt.execute();\
return 'success';\
$$;\
\
\
CALL employee_scd2();\
\
---------SELECT GOLD----------\
SELECT * FROM MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;--2023-12-05 11:41:01.347\
TRUNCATE TABLE MTL_DEV_DB.MTL_GOLD.DIM_EMPLOYEE;\
\
\
\
}