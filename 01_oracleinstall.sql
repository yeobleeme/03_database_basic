-- Oracle 기본 date 형식 변경하기
-- 1. 오라클 환경변수 조회하기
select * from v$nls_parameters;

-- 2. 날짜 형식 변경하기
-- alter session[system] set 시스템변수 = 변경할 값
alter session set NLS_DATE_FORMAT = 'YYYY.MM.DD'; -- date format 변경
alter session set NLS_TIMESTAMP_FORMAT = 'YYYY.MM.DD HH:MI:SS'; -- timestamp format 변경

-- 영구적 (system 레벨) 변경
-- alter system set NLS_DATE_FORMAT = 'YYYY.MM.DD' scope=spfile; -- date format 변경
-- alter system set NLS_TIMESTAMP_FORMAT = 'YYYY.MM.DD HH:MI:SS' scope=spfile; -- timestamp format 변경

-- scope 
-- 1. both : 바로 적용 or 재시작. (에러 확률이 높음)
-- 2. spfile : 재시작 후 적용.
-- SQL command line 에서 system 사용자로 변경 후 DB 재시작.

select * from hr.employees;