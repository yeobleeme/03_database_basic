/*

  function
	
	1. function
	
    보통의 경우 값을 계산하고 그 결과를 반환하기 위해서 fucntion을 사용한다.
		대부분 procedure와 유사하지만
		
		1) in 파라미터만 사용할 수 있다.
		2) 반드시 반환될 값의 데이터타입을 return문 안에 선언해야 한다. 
	
	2. 문법
	
	  1) PL/SQL 블럭 안에는 적어도 한 개의 return문이 있어야 한다.
		2) 선언
		
		  create or replace function 펑션명(arg1 in 데이터타입, ...)
			return 데이터타입 is[as] 
			변수선언...
			begin
			end;
		
	3. 주의사항
	
	  오라클 함수 즉, function에서는 기본적으로 DML(insert, update, delete)문을 사용할 수 없다.
		만약 사용하고자 할 경우 begin 바로 위에 pragma autonomous_transaction을 선언하면 사용할 수 있다.
		
		
	4. procedure vs function
	
	   procedure                  function
   ----------------------------------------------------
	   서버에서 실행 (속도가 빠름)       	     클라이언트에서 실행
		 return값 유무 상관없음    	     return값 필수 
		 return값 복수개 (out 복수개)    return값 한 개
		 파라미터 in, out              in      
		 select절에서 사용 불가          select절에서 사용 가능
		 -> call, execute            -> select function() from dual;
		 
*/

-- 실습. 사원번호를 입력받아 급여를 10% 인상

create or replace function fn_01(p_empno in number) return number is 

 v_sal   number;
 
 pragma autonomous_transaction;
 
begin

 update emp
    set sal = sal * 1.1
	where empno = p_empno;
	
	commit;
	
	select sal 
	  into v_sal
		from emp
	 where empno = p_empno;
	 
	 return v_sal;

end fn_01;

-- call fn_01(7369); -- procedure는 call로 호출이 가능하지만 function의 경우 불가

select fn_01(7369) from dual;

-- 실습. 부피를 계산하는 함수 fn_02
-- 부피 = 길이 * 넓이 * 높이 
create or replace function fn_02 (gili in number
												        , pok in number
												        , nopi in number) return number is 

 bupi  number;
 
begin

 bupi := gili * pok * nopi;
 return bupi;

end fn_02;


select fn_02(10, 10, 10) from dual;
-- sql*plus : execute fn_02(10, 10, 10);

-- 실습. 현재일을 입력받아 해당 월의 마지막 일자를 구하는 함수 
create or replace function fn_03 (v_date date) 
                                  return date is 
																	lastdate date;

begin 

 lastdate := (add_months(v_date, 1) - to_char(v_date, 'DD'));
 return lastdate;

end fn_03;

select fn_03(sysdate) from dual;

-- 실습. '홍길동' 문자열을 전달받아 성을 빼고 이름만 '길동'을 리턴하는 함수 fn_04
create or replace function fn_04(f_name in varchar2)
                                 return varchar2 is
																 o_name varchar2(20);
begin
 o_name := substr(f_name, 2);
 return o_name;
 
end;

select fn_04('홍길동') from dual;
select ename, fn_04(ename) from emp;

-- 실습. fn_05 : 현재일을 입력받아 '2023년 04월 03일' 의 형태로 리턴

create or replace function fn_05(p_date in date)
                        return varchar2 is
												n_date varchar2(30);
begin

n_date := to_char(p_date, 'yyyy"년" MM"월" dd"일"');

return n_date;

end fn_05;

select fn_05(sysdate) from dual;
select name, fn_05(hiredate) from professor;

-- 실습. fn_06 주민번호를 입력받아 남자 or 여자 return // student
select * from student;

create or replace function fn_06(v_jumin in varchar2)
                                 return varchar2 is
																 gender varchar2(2);
begin

 gender := substr(v_jumin, 7, 1);
 
 if gender in('1', '3') 
    then gender := 'M';
	  else gender := 'F';
	 end if;
 
 return gender;

end fn_06;

select name, fn_06(jumin) from student;

-- 실습. fn_07 : professor / hiredate를 현재일 기준으로 근속년월을 계산
--              근속년 floor(), 근속월 ceil() -> ex) 12년 5개월 
select * from professor;

create or replace function fn_07(p_hiredate in date)
													       return varchar2 is
																 gigan varchar2(20);
begin 
gigan := floor(months_between(sysdate, p_hiredate) / 12) || '년' || ' ' ||
							 floor(mod(months_between(sysdate, p_hiredate), 12)) || '월';
return gigan;

end fn_07;

select name, hiredate, fn_07(hiredate) from professor;




-- * 연습문제 *
-- ex01) 두 숫자를 제공하면 덧셈을 해서 결과값을 반환하는 함수를 정의
-- 함수명은 add_num
create or replace function add_num(a in number
                                 , b in number) return number is
	 v_result number;
	 
 begin 
  
	v_result := a + b;
	return v_result;
	
end add_num;

select add_num(1, 2) from dual;

-- ex02) 부서번호를 입력하면 해당 부서에서 근무하는 사원 수를 반환하는 함수를 정의
-- 함수명은 get_emp_count
create or replace function get_emp_count(p_deptno in emp.deptno%type) 
                         return number is 
												 v_result number;
begin 
 
 select count(*)
   into v_result
	 from emp
  where p_deptno = emp.deptno;
	
	return v_result;
 
end get_emp_count;


select * from emp;
select get_emp_count(10) from dual;						 


-- ex03) emp에서 사원번호를 입력하면 해당 사원의 관리자 이름을 구하는 함수
-- 함수명 get_mgr_name

create or replace function get_mgr_name(p_empno in emp.empno%type)
																 return varchar2 is
															   v_result varchar2(10);
begin
 select ename
   into v_result
	 from emp
  where empno = (select mgr from emp where empno = p_empno);
	
	return v_result;

end get_mgr_name;

select * from emp;
select get_mgr_name(7369) from dual;

-- ex04) emp테이블을 이용해서 사원번호를 입력하면 급여 등급을 구하는 함수
-- 4000~5000 A, 3000~4000미만 B, 2000~3000미만 C, 1000~200미만 D, 1000미만 F 
-- 함수명 get_sal_grade
create or replace function get_sal_grade(p_empno in emp.empno%type) 
                                  return varchar2 is
																	v_sal number;
																	grade varchar2(10);
begin

 select sal
   into v_sal
	 from emp
  where p_empno = emp.empno;
	
	case when v_sal between 4000 and 4999 then grade := 'A';
	     when v_sal between 3000 and 3999 then grade := 'B';
			 when v_sal between 2000 and 2999 then grade := 'C';
			 when v_sal between 1000 and 1999 then grade := 'D';
			 when v_sal < 1000 then grade := 'F';
	 end case;
	 
  return grade;
	
end get_sal_grade;


select * from emp;
select get_sal_grade(7369) from dual;


-- ex05) star_wars에 episode를 신규추가등록
-- episode_id = 7, episode_name = '새로운 공화국(New Republic)', open_year=2009
-- 새로운 에피소드를 추가하는 new_star_wars프로시저를 생성

create or replace procedure new_star_wars(p_episode_id in star_wars.episode_id%type
                                        , p_episode_name in star_wars.episode_name%type
																				, p_open_year in star_wars.open_year%type) is
begin
 insert into star_wars values(p_episode, p_episode_name, p_open_year);
end new_star_wars;

call new_star_wars(7, '새로운 공화국(New Republic', 2009);
select * from star_wars;














