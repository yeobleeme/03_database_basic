/*

  인덱스란?
	
	인덱스는 특정 데이터가 HDD의 어느 위치(메모리)에 저장되어 있는지에 대한 정보를 가진
	주소와 같은 개념이다. 인덱스는 데이터와 위치주소(rowid) 정보를 key와 value의 형태의 
	한 쌍으로 저장되어 관리된다.
	인덱스의 가장 큰 목적은 데이터를 보다 빠르게 검색 or 조회할 수 있게 하기 위함이다.
	
	1. rowid 구조
	
	  rowid는 데이터의 위치정보 즉, HDD에 저장되어 있는 메모리주소로서 Oracle에서는 
		총 18Bytes 길이의 정보이다. rowid는 예를들어 AAAW5jAAEAAAFbAAA 의 형태이다
		1) 데이터오브젝트번호 (6) : AAAW5j
		2) 파일번호 (3) : AAE
		3) block번호 (6) : AAAAFb
		4) row번호 (3) : AAA
		
	2. index를 사용하는 이유
	
	  1) 데이터를 보다 신속하게 검색할 수 있게 하도록 사용 (검색속도를 향상) 
		2) 보통 index 테이블의 특정 컬럼에 한 개 이상을 주게되면 index table이 별도로 생성된다.
		   이 index 테이블에는 index 컬럼의 row값과 rowid가 저장되고 row값은 정렬된 b-tree구조로
			 저장시켜 검색시에 보다 빠르게 데이터를 검색할 수 있게 한다.
	  3) 하지만 update, delete, insert 시에 속도가 느려지는 단점이 있다.

  3. index 가 필요한 이유
	
	  1) 데이터가 대용량일 때
		2) where 조건절에 자주 사용되는 컬럼일 경우
		3) 조회 결과 전체 데이터베이스의 3~5% 정도의 경우 index 검색이 효율적이고
		   보다 적은 비용으로 빠르게 검색할 수 있다.
			 
  4. index 가 필요하지 않은 경우
	
	  1) 데이터가 적을 경우 (수천건 미만)에는 index를 설정하지 않는 것이 오히려 성능에 좋다.
		2) 검색보다 update, delete, insert가 빈번하게 일어나는 테이블에는 index가 없는 것이 오히려 좋을 수 있다.
		3) 조회 결과 전체 행의 15% 이상인 경우에는 사용하지 않는 것이 좋다.
		
	5. index가 자동 생성되는 경우
	  
		인덱스가 자동 생성되는 경우는 테이블 정의 시 PK, UK의 제약 조건으로 정의할 때 자동으로 생성된다.
	
	6. 문법
	
	  1) 생성 : create [unique] index 인덱스명 on 테이블명(컬럼1, .., 컬럼n)
		2) 삭제 : drop index 인덱스명
		     --> index는 테이블에 종속되어 있기 때문에 테이블이 삭제가 될 때 자동으로 삭제된다.
	
*/

select rowid, ename from emp;
select rowidtochar(rowid), ename from emp;
-- rowid는 오라클DB 에서만 사용하는 개념으로 rowid를 검색할 수 있다.
-- rowid를 지원하지 않는 프로그램에서는 rowidtochar(rowid) 함수를 이용해서 조회 
select length(rowid) from emp;

select length(rowid)
		 , rowid
		 , ename
		 , empno
  from emp
 where empno = 7521
union all
select length(rowid)
		 , rowid
		 , ename
		 , empno
  from emp
 where ename = 'WARD';

-- index 조회 : data dictionary
select * from all_indexes;
select * from user_indexes;

select * from all_indexes where table_name = 'DEPT2';
select * from all_ind_columns where table_name = 'DEPT2';
select * from all_ind_columns where table_name = 'EMP';

-- index 생성(1) - unique index
create unique index idx_dept2_dname on dept2(dname);

select * from all_indexes where table_name = 'DEPT2';
select * from all_ind_columns where table_name = 'DEPT2';

-- index 생성(2) - non unique index
select * from dept2;

create index idx_dept2_area on dept2(area);

select * from all_indexes where table_name = 'DEPT2';
select * from all_ind_columns where table_name = 'DEPT2';

-- index 생성(3) - 결합 인덱스
select ename, sal, job from emp where ename = 'SMITH' and job = 'CLERK';
select ename, sal, job from emp where ename = 'CLERK' and job = 'SMITH';
select count(*) from emp where ename = 'SMITH';
select count(*) from emp where job = 'CLERK';
select * from all_indexes where table_name = 'EMP';
select * from all_ind_columns where table_name = 'EMP';

create index idx_emp_ename_job on emp(ename, job);
select * from all_indexes where table_name = 'EMP';
select * from all_ind_columns where table_name = 'EMP';

-- index, rebuilding 하기
-- index 생성
drop table idx_test;
create table idx_test(no number);
select * from idx_test;

-- pl/sql
begin
  for i in 1..100000 loop
	  insert into idx_test values(i);
  end loop;
	commit;
end;

select count(*) from idx_test;

-- 인덱스 없이 조회
select * from idx_test order by no;
select * from idx_test where no = 9000;

-- 인덱스 생성 후 조회
create unique index idx_test_no on idx_test(no);
select * from idx_test order by no;
select * from idx_test where no = 9000;


























