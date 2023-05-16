/* 연습문제 */
-- view문제를 기초로 자유롭게 procedure를 작성하세요!
-- 매개변수를 받아서 만드는 것을 기본으로 하고
-- 	dbms_output.put_line('========================================================');
-- 	dbms_output.put_line('교수명' || chr(9) || '교수번호' || chr(9) || '학과명');
-- 	dbms_output.put_line('========================================================');
-- 출력하는 프로시저를 작성해 보세요!!
-- 프로시저명 ex01~ex06

/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회
create or replace procedure ex_01(
  p_name     in professor.name%type;
, p_profno   in professor.profno%type;
, p_dname    in department.dname%type;
)is

 v_name     professor.name%type;
 v_profno   professor.profno%type;
 v_dname    department.dname%type;

begin

dbms_output.put_line('교수이름 ' || p_name);
dbms_output.put_line('교수번호 ' || p_profno);
dbms_output.put_line('소속학과 ' || p_dname);

select prof.name, prof.profno, dpt.dname
  into v_name, v_profno, v_dname
	from professor prof, department dpt
 where prof.deptno = dpt.deptno;

end;






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
create or replace ex_02(




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
create or replace procedure ex_04 is
  type tab_student_type is record (
	  name   student.name%type
	, grade  student.grade%type
	, height student.height%type
 );

 type tab_student_table is table of tab_student_type index by binary_integer;
 
 v_student_table   tab_student_table;

begin 
  select student.name, student.grade, student.height
	  bulk collect 
	  into v_student_table
	  from student
			 , (select std.grade, avg(std.height) avg_height 
			      from student std
		       group by std.grade) grd
	 where student.grade = grd.grade
	   and student.height > grd.avg_height
	 order by student.grade;

   dbms_output.put_line('====================');
 
 for i in 1..v_student_table.count loop
   dbms_output.put_line
	 (v_student_table(i).grade || chr(9) || 
	  v_student_table(i).name || chr(9) || 
		v_student_table(i).height);
 end loop;
 
 exception when others then 
   dbms_output.put_line('에러 발생');
 end ex_04; 

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
