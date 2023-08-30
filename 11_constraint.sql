/*

  제약 조건 constraint
	
	테이블에 정확한 데이터만 입력이 될 수 있도록 사전에 정의(제약)하는 조건을 말한다.
	데이터가 추가될 때 사전에 정의된 제약 조건에 맞지 않는 자료는 DB엔진에서 사전에 방지할 수 있게함.
	
	제약 조건의 종류 
	
	1. not null (NN) : null값이 입력되지 못하게 하는 조건

	2. unique (UK) : UK로 설정된 컬럼에는 중복된 값을 허용하지 않는 조건

	3. primary key (PK) : not null + unique잌 컬럼, PK는 테이블당 한 개의 PK만 정의 가능
	                      PK는 한 개 이상의 컬럼을 묶어서 한 개의 PK로 지정할 수 있다.

	4. foreign key (FK) : 다른 테이블의 PK인 컬럼을 참조(reference) 하도록 하는 조건
	                      부모 테이블의 PK에 없는 값이 자식 테이블에 입력되지 못하게 하는 조건 

	5. check (CK) : 설정된 값만 입력이 되도록 하는 조건

*/

-- 테이블 생성시에 지정

-- 1) 정식 문법
create table new_emp_1 (
  no      number(4)      constraint new_emp_1_no_pk   primary key
, name    varchar2(20)   constraint new_emp_1_nm_nn   not null
, ssn     varchar2(13)   constraint new_emp_1_ssn_uk  unique 
                         constraint new_emp_1_ssn_nn  not null
, loc     number(1)      constraint new_emp_1_nmr_ck  check(loc < 5)
, deptno  varchar2(6)    constraint new_emp_1_dpn_fk  references dept2(dcode)
);

select * from new_emp_1;

-- 2) 약식 문법
create table new_emp_2 (
  no      number(4)      primary key
, name    varchar2(20)   not null
, ssn     varchar2(13)   unique 
                         not null
, loc     number(1)      check(loc < 5)
, deptno  varchar2(6)    references dept2(dcode)
);

select * from new_emp_2;

-- 2. 테이블에 설정된 제약조건 조회
-- data dictionary : xxx_constraint
select * from all_constraints;
select * from user_constraints;
select * from all_constraints
 where table_name like 'NEW_EMP%';

-- 데이터 추가 (제약조건 테스트)
select * from new_emp_1;

insert into new_emp_1 values(1, '홍길동', '8011181234567', 1, 1010);
insert into new_emp_1 values(1, '홍길동', '8011181234567', 1, 1010); -- 에러

insert into new_emp_1 values(2, '홍길동', '8011181234567', 1, 1010);
insert into new_emp_1 values(2, '홍길동', '8011181234567', 1, 1010); -- 에러
insert into new_emp_1 values(2, '홍길상', '8011181234561', 1, 1010);

insert into new_emp_1 values(3, '홍길여', '8011381234567', 1, 1010);

-- 제약 조건 수정
select * from all_constraints
 where table_name = 'NEW_EMP_2';
-- new_emp_2 name에 uk 제약조건을 추가
alter table new_emp_2 add constraint emp_name_uk unique(name);

insert into new_emp_2 values(1, '홍길동', '8011181234567', 1, 1010);
insert into new_emp_2 values(3, '홍길동', '8011181234547', 1, 1010); -- 에러

insert into new_emp_2 values(4, '홍길여', '8011182234547', null, 1010);
-- new_emp_2 loc에 NN 제약조건을 추가
-- 이미 데이터에 null값이 있을 경우 제약조건 추가 불가. 단, null값이 없는 경우 가능
-- 이미 loc에는 check(loc < 5) 제약조건이 있는 경우 제약조건 추가 불가. 따라서 추가가 아닌 수정(modify)로 해야 함
alter table new_emp_2 add constraint emp_loc_nn not null(loc); 
alter table new_emp_2 modify(loc constraint emp_loc_nn not null);

-- FR foreign key 설정
create table c_test1 (
  no     number
, name   varchar2(10)
, deptno number
);
create table c_test2 (
  no     number
, name   varchar2(10)
, deptno number
);
select * from c_test1;
select * from c_test2;

-- primary key / foreign key
-- FK는 참조 테이블의 컬럼이 PK or UK인 컬럼만 FK로 정의할 수 있다.

alter table c_test1 add constraint c_test1_deptno_fk foreign key (deptno) 
            references c_test2(deptno); -- 에러 
						
alter table c_test2 add constraint c2_deptno_uk unique (deptno); -- unique 추가

alter table c_test1 add constraint c_test1_deptno_fk foreign key (deptno) 
            references c_test2(deptno); -- ok
						
select * from all_constraints
        where table_name like 'C_%'

-- FK 제약사항 테스트

insert into c_test1 values(1, '손흥민', 10);

insert into c_test2 values(1, '인사부', 10);

select * from c_test1;
select * from c_test2;

-- 부모 테이블인 c_test2 에서 10 부서 자료 삭제
-- 부모 자료를 삭제하려면 자식 자료를 삭제한 후 가능
delete from c_test1 where deptno = 10;
delete from c_test2 where deptno = 10;

-- FK 관계에서 부모 테이블 자료를 삭제할 수 있도록 정의하는 옵션
-- cascade 옵션
-- 1) 부모와 자식을 동시에 삭제 옵션
-- 2) 부모는 삭제하고 자식에는 FK 컬럼을 null로 업데이트 옵션
drop table c_test1;
drop table c_test2;

insert into c_test2 values(1, '인사부', 10);
insert into c_test1 values(1, '손흥민', 10);

alter table c_test1 add constraint c1_deptno_fk foreign key(deptno) references c_test2(deptno)
   on delete cascade;

-- on delete cascade : 부모 자료 삭제 -> 자식 자료도 삭제
delete from c_test2 where deptno = 10;

select * from c_test1;
select * from c_test2;

-- on delete set null : 부모 자료 삭제 -> 자식 자료 null 값으로 변경
alter table c_test1 add constraint c1_deptno_fk foreign key(deptno) references c_test2(deptno)
   on delete set null;

delete from c_test2 where deptno = 10;

select * from c_test1;
select * from c_test2;
































