{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 --------SELECT BRONZE TABLE-----------------------\
SELECT * FROM MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE;\
\
--------------CREATE OR REPLACE BRONZE STREAM-----------------\
CREATE OR REPLACE STREAM MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE_ST\
ON TABLE  MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE;\
\
--------------SELECT STREAM--------------\
SELECT * FROM MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE_ST;\
SHOW STREAMS;\
DESC STREAM MTL_DEV_DB.MTL_BRONZE.BZ_EMPLOYEE_ST;\
\
-----------SELECT SILVER TABLE------------------------------\
SELECT * FROM MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;\
TRUNCATE TABLE MTL_DEV_DB.MTL_SILVER.SL_EMPLOYEE;}