{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 ---------------TO FIND UNIQUE COMBINATIONS OF COLUMN VALUES----------------------\
\
SELECT * FROM BZ_EMPLOYEE;\
SELECT COUNT(*) FROM BZ_EMPLOYEE;\
\
SELECT COUNT(*)\
FROM (\
SELECT DISTINCT\
EMP_NO,\
EMP_TYPE,\
ADDRESS\
FROM BZ_EMPLOYEE\
)a;\
\
SELECT DISTINCT\
EMP_NO,\
EMP_TYPE,\
ADDRESS,\
COUNT(*)\
FROM BZ_EMPLOYEE\
GROUP BY EMP_NO,EMP_TYPE, ADDRESS;\
\
SELECT * FROM BZ_EMPLOYEE WHERE EMP_NO = '12.00' AND EMP_TYPE= 'RSM';}