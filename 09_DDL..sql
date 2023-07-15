/*
  테이블 생성
	
	1. 문법
	
	  create table 테이블명( 
		   컬럼명   데이터타입(크기)   default 기본값
			 컬럼명   데이터타입(크기)   default 기본값
		 , 컬렴명 ... 
		);
		
	2. 데이터 타입
	
	 1) 문자형
	 
	   a. char(n) : 고정길이 / 최대 2KB / 기본길이 1byte
		 b. varchar2(n) : 가변길이 ? 최대 4KB / 기본길이 1byte
		 c. long : 가변길이 / 최대 2GB 
	 
	 2) 숫자형
	 
	  a. number(p, s) : 가변숫자 / p(1~38, 기본값=38), s(-84~127, 기본=0) / 최대 22byte 
		b. float(p) : number의 하위타입 p(1~128, 기본값=128) / 최대 22byte
	 
	 3) 날짜형
	 
	  a. date : bc 4712.01.01 ! 9999.12.31 까지 년월시분초 까지 표현
		b. timestamp : 년월시분초밀리초 까지 표현
		
	 4) lob타입 : (Large Object) 대용량의 데이터를 저장할 수 있는 데이터타입
	             일반적으로 그래프, 이미지, 동영상, 음악파일 등 비정형 데이터를 저장할 때 사용.
							 문자형 대용량 데이터는 CLOB or NLOB를 사용/ 이미지, 동영상 등의 데이터는 BLOB or BFILE 사용
	 
	   a. clob : 문자형 대용량 객체, 고정길이와 가변길이 문자형을 지원
		 b. blob : 이진형 대용량 객체, 주로 멀티미디어 자료를 저장
		 c. bfile : 대용량 이진파일에 대한 파일의 위치와 이름을 저장
	
*/


-- 테이블 생성

create table mytable(
  no         number(3,1)
, name       varchar2(10)
, hiredate   date
);

select * from mytable;

create table 마이테이블(
  번호        number(3,1)
, 이름        varchar2(10)
, 입사일       date
);

select * from 마이테이블;

/*

  테이블 생성시 주의사항
	
	1. 테이블 이름은 반드시 문자로 시작해야 한다. 중간에 숫자 포함 가능.
	2. 특수문자도 가능하지만 단, 테이블 생성시 큰 따옴표""로 감싸야 한다. 권장X
	3. 테이블 이름과 컬럼명은 최대 30byte 까지 가능 (utf-8 한글 10자, euckr 15자)
	4. 동일 사용자(스키마) 안에서는 테이블명을 중복 정의할 수 없다.
	5. 테이블명이나 컬럼명은 오라클 키워드를 사용하지 않는 것을 권장.(사용X)
*/

-- 1. 테이블에 자료 추가
-- a. 문법
-- insert into mytable(컬럼1, ...컬럼n) values(값1, ...값n)
-- b. 제약사항
-- 컬럼의 갯수와 값의 갯수는 동일해야 한다.
-- 컬럼의 데이터타입과 값의 데이터타입은 동일해야 한다.
--  단, 형변환(자동형변환)이 가능하다면 사용할 수 있지만 변환이 불가능하다면 에러 발생.

select * from mytable;

insert into mytable(name) values('홍길동');
insert into mytable(no, name) values(1, '홍길동');
insert into mytable(no, name) values(2, '홍길순');
insert into mytable(no, name) values(3, '홍길자');
insert into mytable(no, name) values(4, '홍길성');
insert into mytable(no, name) values(5, '홍길상');
insert into mytable(no, name) values(1, '손흥민');
insert into mytable(no, name, hiredate) values(6, '김민재', sysdate); 
insert into mytable(no, name, hiredate) values(7, 10000, sysdate); 
insert into mytable(no, name, hiredate) values(8, '이강인', '2023.03.27'); 
insert into mytable(no, name, hiredate) values(9, '소향', '2023-03-27');

insert into mytable(no, name, hiredate) values(100, '거미', sysdate);

-- 2. 테이블 복사
-- emp 테이블을 temptable로 복사
-- select 명령으로 복사 가능.
-- create table temptable 데이터타입, (empno, ename, hiredate ...);

select * from emp;
-- 1) 테이블 구조 및 데이터 복사할 경우
create table temptable as
select * from emp;

select * from temptable;

-- 2) 테이블 구조만 복사
create table temptable as 
select * from emp where 1=2;

-- 테이블 삭제 명령
-- drop table 테이블명;
drop table mytable;
drop table temptable;
drop table 마이테이블;

-- 3) 테이블 구조 및 특정 자료만 복사
drop table temptable;

create table temptable as
select * from emp where deptno = 10;

select * from temptable;

/*
  테이블 수정하기
	
	1. 컬럼 추가 : alter table 테이블명 add(추가컬럼명 데이터타입)
	2. 컬럼명 변경 : alter table 테이블명 rename column 변경전이름 to 변경후이름
	3. 데이터타입 변경 : alter table 테이블명 modify(변경할컬럼 변경할데이터타입)
	4. 컬럼 삭제 : alter table 테이블명 drop column 삭제할컬럼명
	
*/

-- 실습 dept2 테이블을 dept6로 복사
create table dept6 as
select * from dept2;

select * from dept6;

-- 1. 컬럼추가 : dept6 location varchar2(10)
alter table dept6 add(location varchar2(10));
select * from dept6;

-- 2. 컬럼명 변경 : location -> loc
alter table dept6 rename column location to loc;
select * from dept6;

-- 3. 데이터 타입 변경 : dename -> number, loc -> number
-- 데이터타입을 변경할 경우 기존 데이터에 따라 변경 가능한 티입이라면 변경할 수 있지만
-- 변환 불가한 데이터가 있을 경우에는 에러 발생
alter table dept6 modify(dname number);
alter table dept6 modify(loc number); -- 값이 하나도 없기 때문에 변경 가능

-- 4. 오라클 테이블 정보 조회
select * from all_tab_columns
 where table_name = 'DEPT6';
select * from all_tab_columns
 where table_name = 'EMP';
 
-- 5. 컬럼 추가시에 기본값default 설정
create table dept7 as select * from dept2;
select * from dept7;

alter table dept7 add(location varchar2(10) default '서울');
select * from dept7;
alter table dept7 add(xxx number default 0);
select * from dept7;
alter table dept7 add(create_date date default sysdate);
select * from dept7;

-- 6. 컬럼의 크기 변경
-- location 10자리를 1자리로 변경
alter table dept7 modify(location varchar2(1));
alter table dept7 modify(location varchar2(6));

select * from dept7;

select * from all_tab_columns
 where table_name = 'DEPT7';
 
-- 7. 컬럼 삭제
alter table dept7 drop column xxx;

/*
  테이블 수정
	
	1. 테이블명 변경 : alter table 변경전 rename to 변경후;
	2. 테이블 삭제 (자료만) : truncate table 테이블명;
	3. 테이블 삭제 (완전삭제) : drop table 테이블명;
	
*/

-- 테이블명 변경
alter table dept7 rename to dept777;
select * from all_tab_columns
 where table_name = 'DEPT777';

-- truncate 
truncate table dept777;
select * from dept777;

-- drop
drop table dept777;
drop table dept6;
drop table mytable;
drop table temptable;
drop table 마이테이블;

-- 읽기 전용 테이블 생성
-- alter table 테이블명 read only;
create table tbl_read_only(
   no   number
 , name varchar2(20)
 );
 
insert into tbl_read_only(no, name) values(1, '오타니');
insert into tbl_read_only values(1, '오타니'); -- 생략 가능

select * from tbl_read_only;

alter table tbl_read_only read only;
insert into tbl_read_only values(2, '손흥민'); -- 에러 

-- 읽기 전용을 읽기/쓰기로 변경
-- read write
alter table tbl_read_only read write;
insert into tbl_read_only values(2, '손흥민');

/*
  E. Data Dictionary
	오라클 데이터베이스의 메모리 구조와 테이블에 대한 구조 정보를 갖고있다.
	각 객체(table, view, index ...)등이 사용하고 있는 공간 정보, 제약 조건, 사용자 정보 및 권한
	프로파일, Role, 감사(Audit)등의 정보를 제공한다.
	
	1. 데이터딕셔너리
	    
		1) 데이터베이스 자원들을 효율적으로 관리하기 위해 다양한 정보를 저장하고 있는 시스템이다.
		2) 사용자가 테이블을 생성하거나 변경하는 등의 작업을 할 때 데이터베이스 서버(엔진)에 의해
		   자동으로 갱신되는 테이블이다.
	  3) 사용자가 데이터딕셔너리의 내용을 수정하거나 삭제할 수 없다.
		4) 사용자가 데이터딕셔너리를 조회할 경우에 시스템이 직접 관리하는 테이블은 암호화 되어있기 때문에 내용을 볼 수 없다.
		
	2. 데이터딕셔너리 뷰 : 오라클은 데이터딕셔너리의 내용을 사용자가 이해할 수 있는 내용으로 변환하여 제공
	
	  1) user_xxx
		 a. 자신 계정이 소유한 객체에 대한 정보를 조회
		 b. user라는 접두어가 붙은 데이터딕셔너리 중 자신이 생성한 테이블, 인덱스, 뷰 등과 같은
		    자신이 소유한 객체의 정보를 저장하는 user_tables가 있다. 
				-> select * from user_tables;
				
		2) all_xxx
		 a. 자신 계정 소유와 권한을 부여받은 객체 등에 대한 정보를 조회할 수 있다.
		 b. 타 계정의 객체는 원칙적으로 접근이 불가능하지만 그 객체의 소유자가 접근할 수 있도록
		    권한을 부여한 경우에는 타 계정의 객체에도 접근할 수 있다.
				-> select * from all_tables;
				-> select * from all_tables where owner = 'HR';
		
		3) dba_xxx
		 a. 데이터베이스 관리자만 접근이 가능한 객체들의 정보를 조회할 수 있다.
		 b. dba 딕셔너리는 DBA 권한을 가진 사용자는 모두 접근이 가능하다.
		    즉, DB에 있는 모든 객체들에 대한 정보를 조회할 수 있다.
		 c. 따라서, dba 권한을 가진 sys, system 계정으로 접속하면 dba_xxx 등의 내용을 조회할 수 있다.
	
*/
select * from dictionary;

select * from user_cons_columns;

select * from user_tables;
select * from all_tables;
select * from dba_tables;


-- ex01
create table new_emp(
  no         number(5)
, name       varchar2(20)
, hiredate   date
, bonus      number(6,2)
);

select * from new_emp;

select * from all_tab_columns
 where table_name = 'new_emp';

-- ex02
create table new_emp2 as
select * from new_emp;

alter table new_emp2 drop column bonus;

select * from new_emp2;

-- ex03
create table new_emp3 as
select * from new_emp2 where 1=2;

select * from new_emp3;

-- ex04
alter table new_emp2 add(birthday date default sysdate);

select * from new_emp2;

-- ex05
alter table new_emp2 rename column birthday to birth;

select * from new_emp2;

-- ex06
alter table new_emp2 modify(no number(7));

select * from all_tab_columns
 where table_name = 'new_emp2';
 
-- ex07
alter table new_emp2 drop column birth;

select * from new_emp2;

-- ex08
delete from new_emp
 where .. and 

-- ex09
drop table new_emp2;

-- ex10































