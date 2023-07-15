/*

  View
	
	1. view란 가상의 테이블이다. 
	2. view에는 실제 데이터가 존재하지 않고 view를 통해서 데이터만 조회할 수 있다.
	3. view는 복잡한 query를 통해 조회할 수 있는 결과를 사전에 정의한 view를 통해
	   간단히 조회할 수 있게 한다.
  4. 한 개의 view로 여러 개의 Table 데이터를 검색할 수 있게 한다.
	5. 특정 기준에 따라 사용자 별 다른 조회 결과를 얻을 수 있게 한다.
	
	view의 제한 조건
	
	1. 테이블에 not null로 만든 컬럼들이 view에 포함되어야 한다.
	2. view를 통해서도 데이터를 insert할 수 있다. 단, rowid, rownum, nextval, curval
	   등과 같은 가상의 컬럼에 대해 참조하고 있을 경우에 가능하다.
  3. with read only 옵션으로 설정된 view는 어떠한 데이터도 갱신할 수 없다.
	4. with check option을 설정한 view는 view 조건에 해당되는 데이터망 삽입, 삭제, 수정할 수 있다. 
	
	문법
	
	create [or replace] [force|noforce] view 뷰이름 as 
	서브쿼리...
	with read only 
	with check option
	
	1. or replace : 동일 이름의 view가 존재할 경우 삭제 후 다시 생성(대체)
	2. force|noforce : 테이블의 존재유무와 관계없이 view를 생성할 것인지 여부
	3. with read only : 조회만 가능한 view 
	4. with check option : 주어진 check 옵션 즉, 제약 조건에 맞는 데이터만 입력하거나 수정 가능
	
	view 조회 방법
	
	테이블과 동일한 문법 사용
	
	view를 생성할 수 있는 권한 부여
	
	1. 사용자 권한 조회 : select * from user_role_privs;
	2. 권한 부여 : sysdba 권한으로 부여 가능 
						   grant create view to scott(사용자계정/스키마)

*/

select * from emp;

create or replace view v_emp as
select ename, job, deptno from emp;

-- 1. create view 권한 부여
grant connect, resource to scott;
grant create view to scott;

-- 2. 권한 조회
select * from user_role_privs;

-- 3. 단순 view 생성
create or replace view v_emp as
select ename, job, deptno from emp;

select * from v_emp;

-- 4. 사용자 view 목록 조회
select * from user_views;

select * from emp;
select * from dept;

-- 5. 복합 view 생성
create or replace view v_emp_dname as
select emp.ename, dept.dname, emp.deptno
  from emp, dept
 where emp.deptno = dept.deptno;
 
select * from v_emp_dname;

-- 실습. 급여(sal, comm)가 포함된 view 
-- 예) 급여조회 권한이 있는 담당자만 사용할 수 있는 view
create or replace view v_emp_sal as
select empno 사원번호
     , ename 사원이름
		 , job   직급
		 , sal   급여
		 , nvl(comm, 0) 커미션
  from emp;

select * from v_emp_sal;
select * from v_emp_sal where job = 'CLERK'; -- 에러
select * from v_emp_sal where 직급 = 'CLERK';

select *
  from (select empno 사원번호
             , ename 사원이름
        		 , job   직급
	        	 , sal   급여
	        	 , nvl(comm, 0) 커미션
             from emp);
						 
-- 6. table과 view의 join?
select emp.deptno, v_emp.*
  from emp emp, v_emp_sal v_emp
 where emp.empno = v_emp.사원번호;
 
create or replace view v_test as 
select emp.deptno, v_emp.*
  from emp emp, v_emp_sal v_emp
 where emp.empno = v_emp.사원번호;
 
select * from v_test;

-- 실습. emp에서 부서번호, dept에서 dname
--      v_emp_sal 와 join 
--   -> 사원번호, 사원이름, 부서명, 직급, 급여 출력 join query
select * from v_emp_sal;
select * from emp;
select * from dept;

create or replace view v_test2 as
select emp.deptno
     , dpt.dname
		 , sal.*
  from emp emp
	   , dept dpt
	   , v_emp_sal sal
 where emp.deptno = dpt.deptno
   and emp.empno = sal.사원번호;
	 
select * from v_test2;

SELECT
	V_EMP_SAL."사원번호", 
	V_EMP_SAL."사원이름", 
	DEPT.DNAME "부서명", 
	EMP.JOB "직급", 
	EMP.SAL "급여", 
	nvl(EMP.COMM, 0) "커미션"
FROM
	V_EMP_SAL,
	EMP
	INNER JOIN
	DEPT
	ON 
		EMP.DEPTNO = DEPT.DEPTNO;
		
-- 7. inline view
--    제약 사항 : 한 개의 컬럼만 정의 가능
select emp.ename
     , dpt.dname
  from emp emp
	   , dept dpt
 where emp.deptno = dpt.deptno;
 
 select emp.ename
      , (select dname from dept dpt where emp.deptno = dpt.deptno) dname
   from emp emp;
	 
-- 8. view 삭제
drop view v_test2;

-- 실습. emp와 dept를 조회 : 부서번호화 부서별 최대급여 및 부서명을 조회
-- 1) view를 생성
-- 2) inline view로 작성
-- deptno, dname, max_sal :
-- view 이름 : v_max_sal_01

select * from emp;
select * from dept;

create or replace view v_max_sal_01 as
select deptno
     , max(sal) 최대급여
  from emp
 group by deptno
 order by deptno;

select * from v_max_sal_01;

select d.deptno
     , d.dname
		 , m.최대급여
  from dept d
	   , v_max_sal_01 m
 where d.deptno = m.deptno;

create or replace view v_max_sal_02 as
select emp.deptno 부서번호
     , dpt.dname 부서이름
		 , max(sal) 최대급여
  from emp emp
	   , dept dpt
 where emp.deptno = dpt.deptno
 group by emp.deptno, dpt.dname
 order by emp.deptno;

select * from v_max_sal_02;

-- inline view (서브쿼리 - inline view에 group by 사용)
create or replace view v_max_sal_03 as
select dpt.deptno
		 , dpt.dname
		 , sal.max_sal
  from dept dpt
	   , (select deptno, sum(sal) as max_sal from emp group by deptno) sal
 where dpt.deptno = sal.deptno;

select * from v_max_sal_03;

-- inline view 
create or replace view v_max_sal_04 as
select dpt.deptno
     , dpt.dname
		 , nvl((select max(sal) from emp emp where dpt.deptno = emp.deptno group by deptno), 0)
  from dept dpt;
	
select * from v_max_sal_04;

/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View
select * from professor;
select * from department;

create or replace view prof_dept_01 as 
select prof.profno 교수번호
     , prof.name 교수이름
		 , dept.dname 소속학과
  from professor prof, department dept
 where prof.deptno = dept.deptno;

select * from prof_dept_01;

-- ex02) inline view를 사용, student, department를 사용 학과별로 
-- 학생들의 최대키, 최대몸무게, 학과명을 출력
select * from student;
select * from department;

create or replace view stu_hw_01 as
select std.max_height 최대키
		 , std.max_weight 최대몸무게
		 , dept.dname 학과명
  from (select deptno1, max(height) max_height, max(weight) max_weight
          from student group by deptno1 std
		 , department dept
 where std.deptno1 = dept.deptno;
 
 select * from stu_hw_01;
 
-- ex03) inline view를 사용, 학과명, 학과별최대키, 학과별로 가장 키가 큰 학생들의
-- 이름과 키를 출력
create or replace view stu_hwn_01 as
select dept.dname 학과명
     , d_max.height 학과최대키
		 , std.name 학생명
		 , std.height 학생키
  from (select deptno1, max(height) height from student group by deptno1) d_max
	   , student std, department dept
 where std.deptno1 = dept.deptno
	 and d_max.height = std.height 
	 and std.deptno1 = d_max.deptno1;

select * from stu_hwn_01;

-- ex04) student에서 학생키가 동일학년의 평균키보다 큰 학생들의 학년과 이름과 키
-- 해당 학년의 평균키를 출력 단, inline view로
select * from student;

create or replace view stu_ah_01 as
select std.grade 학년
     , avg.height 평균키
		 , std.name 평균키넘는학생
		 , std.height 학생키
  from (select grade, avg(height) height from student group by grade) avg
	   , student std
 where std.height > avg.height
	 and std.grade = avg.grade
 order by std.grade;	

select * from stu_ah_01;

-- ex05) professor에서 교수들의 급여순위와 이름, 급여출력 단, 급여순위 1~5위까지
-- create.....
select * from professor;

create or replace view prof_sr_01 as
select rownum 급여순위
		 , name 이름
		 , pay 급여
  from (select name, pay from professor order by pay desc)
 where rownum between 1 and 5;
 
create or replace view prof_sr_01 as
select rownum, t1.*
from (select pro.name, pro.pay from professor pro order by pro.pay desc) t1
where rownum <= 5;

select * from prof_sr_01;

-- ex06) 교수번호정렬후 3건씩해서 급여합계와 급여평균을 출력
-- hint) 
-- select rownum, profno, pay, ceil(rownum/3) from professor; 
-- rollup

select rownum, profno, pay, ceil(rownum/3) from professor; -- rollup

select profno
		 , name
		 , pay
		 , sum(pay)
		 , round(avg(pay), 1)
	from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(profno, name, pay)
 order by ceil(rownum/3);


















