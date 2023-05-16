/*

  join 문법
	
	1. Oracle 문법
	
	   select t1.ename, t2.dname
		   from emp t1, dept t2
			 where t1.deptno = t2.deptno
	
	2. Ansi join
	
	   select t1.ename, t2.dname
		   from emp t1 [innner|outer|full] join dept t2 on t1.deptno = t2.deptno
 
*/

select deptno, ename from emp;
select deptno, dname from dept;

-- Oracle join
select ename, dname, emp.deptno
  from emp, dept
 where emp.deptno = dept.deptno;

select ename, dname, e.deptno
  from emp e, dept d
 where e.deptno = d.deptno;
 
 -- Ansi join
 select ename, dname
   from emp join dept on emp.deptno = dept.deptno;
 
 select ename, dname
   from emp inner join dept on emp.deptno = dept.deptno;
	 
-- table 의 별칭 
 select e.ename, d.dname, e.deptno
  from emp e, dept d
 where e.deptno = d.deptno;
 
 /*
   join의 종류
	 
	 1. equi-join (등가) = inner join
	 2. outer join
	 3. full join
	 
 */

-- A. equi-join 
-- 실습1. student, professor 에서 지도교수의 이름과 학생이름을 출력
-- oracle / ansi 각각
-- 학생명과 교수명만 출력

select * from student;
select * from professor;

-- oracle
select std.name 학생이름, pro.name 지도교수
  from student std, professor pro
 where std.deptno1 = pro.deptno;
 
select std.name 학생이름, pro.name 지도교수
  from student std, professor pro
 where std.profno = pro.profno;
 
-- ansi
select std.name 학생이름, pro.name 지도교수
  from student std inner join professor prd 
	on std.profno = pro.profno;

select * from department;

select pro.name 교수명, std.name 학생명
  from professor pro inner join student std
	  on std.profno = pro.profno;

-- 실습2. student, professor, department 에서 교수명, 학생명, 학과명을 출력
-- 표준문법Oracle (where, and), ansi (inner x2) 각각

select * from student;
select * from professor;
select * from department;

-- Oracle 
select student.name, professor.name, department.dname
  from student, professor, department
 where student.profno = professor.profno 
   and professor.deptno = department.deptno;

-- Ansi 
select student.name, professor.name, department.dname
  from student 
	inner join professor on student.profno = professor.profno
	inner join department on professor.deptno = department.deptno;
	
select student.name, professor.name, department.dname
  from student 
	inner join professor on student.profno = professor.profno
	inner join department on student.deptno1 = department.deptno;

-- outer-join
select count(*) from student;
select count(*) from student where profno is null;

-- 지도교수가 정해져 있지 않은 학생까지도 출력
-- Oracle에서만 사용되는 문법

-- 지도교수가 할당되지 않은 학생
select std.name 학생명, pro.name 교수명
  from student std, professor pro
 where std.profno = pro.profno(+);

-- 학생이 할당되지 않은 지도교수까지 
select std.name 학생명, pro.name 교수명
  from student std, professor pro
 where std.profno(+) = pro.profno;

-- Ansi outer-join
select std.name 학생명, pro.name 교수명
  from student std join professor pro on std.profno = pro.profno;
 
select std.name 학생명, pro.name 교수명
  from student std left outer join professor pro on std.profno = pro.profno;

select std.name 학생명, pro.name 교수명
  from student std right outer join professor pro on std.profno = pro.profno;	
	

-- self join
select empno from emp;
select mgr from emp;

select emp.empno, emp.ename -- 사원
     , mgr.empno, mgr.ename -- 해당 사원의 매니저
	from emp emp, emp mgr
 where emp.mgr = mgr.empno;


/* 연습문제 */

-- ex01) student, department에서 학생이름, 학과번호, 1전공학과명출력

select * from student;
select * from department;

-- Oracle
select student.name, student.deptno1, department.dname
  from student, department
 where student.deptno1 = department.deptno;

-- Ansi 
select student.name, student.deptno1, department.dname
  from student 
	left outer join department on student.deptno1 = department.deptno;

-- ex02) emp2, p_grade에서 현재 직급의 사원명, 직급, 현재 년봉, 해당직급의 하한
--       상한금액 출력 (천단위 ,로 구분)

select * from emp2;
select * from p_grade;

-- Oracle
select emp2.name, emp2.position, emp2.pay, pg.s_pay, pg.e_pay
  from emp2, p_grade pg
 where emp2.position = pg.position;
 
-- Ansi
select emp2.name, emp2.position, emp2.pay, pg.s_pay, pg.e_pay
  from emp2 join p_grade pg
	  on emp2.position = pg.position;
    
-- ex03) emp2, p_grade에서 사원명, 나이, 직급, 예상직급(나이로 계산후 해당 나이의
--       직급), 나이는 오늘날자기준 trunc로 소수점이하 절삭 

select * from emp2;
select * from p_grade;

select emp2.name, trunc((sysdate - emp2.birthday) / 365, 0) + 1 age
		 , emp2.position
		 , pg.position
  from emp2, p_grade pg
 where trunc((sysdate - emp2.birthday) / 365, 0) + 1
   between pg.s_age(+) and pg.e_age(+)
	 order by age;

-- ex04) customer, gift 고객포인트보나 낮은 포인트의 상품중에 Notebook을 선택할
--       수 있는 고객명, 포인트, 상품명을 출력  

select * from customer;
select * from gift;

select c.gname, c.point, g.gname
  from customer c, gift g
 where c.point >= g.g_start
   and g.gname = 'Notebook';
	 
select c.gname, c.point, g.gname
  from customer c join gift g
    on c.point >= g.g_start
   and g.gname = 'Notebook';

-- ex05) professor에서 교수번호, 교수명, 입사일, 자신보다 빠른 사람의 인원수
--       단, 입사일이 빠른 사람수를 오름차순으로

select * from professor;

select p1.profno, p1.name, to_char(p1.hiredate, 'YYYY/MM/DD') hiredate,
       count(p2.hiredate) count
	from professor p1, professor p2
 where p1.hiredate > p2.hiredate(+)
 group by p1.profno, p1.name, p1.hiredate
 order by 4;

 
-- ex06) emp에서 사원번호, 사원명, 입사일 자신보다 먼저 입사한 인원수를 출력
--       단, 입사일이 빠른 사람수를 오름차순 정렬

select * from emp;

select e1.empno, e1.ename, to_char(e1.hiredate, 'YYYY/MM/DD') as hiredate,
       count(nvl2(e2.empno, e1.empno, null)) count
  from emp e1, emp e2
 where e1.hiredate > e2.hiredate(+)
 group by e1.empno, e1.ename, e1.hiredate
 order by count asc;
 

 
 
 
 
 






