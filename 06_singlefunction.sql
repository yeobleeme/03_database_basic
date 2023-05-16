/*

  단일행 함수 (single function)
	
	A. 문자 함수
	
	 1. upper / lower : 대소문자 변환 함수 upper('abcde') => ABCDE
	 
	 2. initcap : 첫 글자를 대문자로 나머지는 소문자 initcap('aBcDe') => Abcde
	 
	 3. length : 문자열의 길이를 리턴 
	    length('abcde') => 5
			length('한글') => 2
			
	 4. lengthb : 문자열의 byte 단위 리턴 
	    (영문 1byte, 한글의 경우 문자셋에 따라 euc-kr 2byte or utf-8 3byte)
			
	 5. concat : 문자열을 연결 (|| 와 동일)
	    concat('a','b') => ab
			
	 6. substr : 주어진 문자열에서 특정 위치의 문자를 추출
	    substr('aBcDe' ,2, 2) => Bc ('문자열', 스타트, 갯수)
	 
	 7. substrb : 주어진 문자열에서 특정 위치의 byte만 추출
	    substrb('한글', 1, 2) => euc-kr 한 / utf-8 깨진 문자
	 
	 8. instr : 주어진 문자열에서 특정 문자의 위치를 리턴
		  instr('A*B#C#D', '#') => 4
			
	 9. instrb : 주어진 문자열에서 특정 바이트의 위치를 리턴
	    instrb('한글로', '로') => (utf-8) 7
			
	 10. lpad : 주어진 문자열에서 특정 문자를 앞에서부터 채움
	     lpad('love', 6, '*') => **love
			 
	 11. rpad : 주어진 문자열에서 특정 문자를 뒤에서부터 채움
	     rpad('love', 6, '*') => love**
			 
	 12. ltrim : 주어진 문자열에서 앞의 특정 문자를 삭제
			 ltrim('*love', '*') => love
			 
	 13. rtrim : 주어진 문자열에서 뒤의 특정 문자를 삭제
	     rtrim('love+', '+') => love
	 
	 14. replace : 주어진 문자열에서 A를 B로 치환 
	     replace('AB', 'A', 'C') => CB
			 
	*/
	
-- upper() / lower()
select ename from emp;
select lower(ename) from emp;
select upper(lower(ename)) from emp;

-- initcap()
select initcap(ename) from emp;

-- length() / lengthb()
select ename, length(ename) from emp;
select '소향' from dual; 
select * from dual; -- dual = 오라클에서 제공해주는 dummy 테이블
select '소향', dummy from dual; 
select '소향', length('소향') from dual;
select '소향', lengthb('소향') from dual;

-- concat() or ||
select name, id 
  from professor;
	
select name, id
  , concat(name, id)
	, concat (name, ' - ') "name - "
	
	, concat(concat(name, ' - '), id) "name - id"
	, concat(concat('홍길동의 직업은 ', '의적 입니다.'), ' 주소는 조선 한양 입니다.') as 홍길동
  
	, name || ' - ' || id as "name - id"
	, '홍길동의 직업은' || '의적 입니다.' || ' 주소는 조선 한양 입니다.' as "홍길동(2)"
	from professor;
	
-- substr(값, from, lengh) / substrb(값, from, length)
-- 시작 위치가 음수이면 뒤에서부터 검색
select 'abcdef'
      , substr('abcdef', 3)
			, substr('abcdef', 3, 2)
			, substr('abcdef', -3)
			, substr('abcdef', -3, 2)
  from dual;
	
select '홍길동'
     , substr('홍길동', 1, 1)
		 , substrb('홍길동', 1, 1)
		 , substrb('홍길동', 1, 2)
		 , substrb('홍길동', 1, 3)
  from dual;
	
-- 실습. ssn 991118-1234567 에서 성별구분만 추출해 보기
select '991118-1234567'
      , substr('991118-1234567',8, 1) as 성별
	from	dual;
	
-- instr(문자열, 검색글자, from기본값1, to기본값1)
-- 검색 글자의 위치를 리턴. 시작 위치가 음수이면 뒤에서부터 검색
select 'A*B*C*D'
     , instr('A*B*C*D', '*')
		 , instr('A*B*C*D', '*', 3)
		 , instr('A*B*C*D', '*', 1, 2) -- 처음부터 시작해서 2번째의 * 위치
		 , instr('A*B*C*D', '*', -5, 1) -- 뒤에서 5번째 위치부터
		 , instr('A*B*C*D', '*', -1, 2) 	
  from dual;
	
select 'HELLO WORLD'
      , instr('HELLO WORLD', 'O')
			, instr('HELLO WORLD', 'O', -1)
			, instr('HELLO WORLD', 'O', -1, 1)
			, instr('HELLO WORLD', 'O', -1, 2)
  from dual;

-- lpad(문자열, 자리수, 채울문자) / rpad(문자열, 자리수, 채울문자)
select name, id, length(id)
     , lpad(id, 10) -- 채울 문자가 정의되지 않으면 공백처리
		 , lpad(id, 10, '*')
		 , rpad(id, 10, '*')
  from student
where deptno1 = 101;

-- ltrim / rtrim 
select ename
		 , ltrim(ename, 'C')
		 , rtrim(ename, 'R')
  from emp
 where deptno = 10;
 
select '   xxx   ' from dual union all
select ltrim('   xxx   ') from dual union all
select rtrim('   xxx   ') from dual;

-- replace(문자열, 변경 전 문자, 변경 후 문자)
select ename 
     , replace(ename, 'KI', '**')
		 , replace(ename, 'I', '---')
		 -- **ARK, **NG, **LLER substr(), replace()
     , replace(ename, substr(ename, 1, 2), '**')
  from emp
 where deptno = 10;
 
 
 -- 연습문제
 -- ex01) student 테이블의 주민등록번호에서 성별만 추출
select * from student;
select name, jumin
		  , substr(jumin, 7, 1)
   from student;
	 
 -- ex02) student 테이블의 주민등록번호에서 월일만 추출
select * from student;
select name, jumin
		  , substr(jumin, 3, 4)
   from student;
	 
 -- ex03) 70년대에 태어난 사람만 추출
select * from student;

select name
   from student
  where substr(jumin, 1, 2) < 80 and substr(jumin, 1, 2) >= 70;
	 

 -- ex04) student 테이블에서 jumin 컬럼을 사용, 1전공이 101번인 학생들의
 --       이름과 태어난 월일, 생일 하루 전 날짜를 출력

select jumin
	   , name, substr(jumin, 3, 4) 생일
	   , substr(jumin, 3, 2) || (substr(jumin, 5, 2)-1) 생일하루전
  from student
 where deptno1 = 101;
 
 
 -- 형 변환 함수, 자동(묵시적) 형 변환, 수동(명시적) 형 변환
	
	/*
	
	B. 숫자 함수
 
  1. round : 주어진 실수를 반올림
	2. trunc : 주어진 실수를 버림
	3. mod : 나누기 연산 후 나머지 값을 리턴 
	4. ceil : 주어진 실수값에서 가장 큰 정수값을 리턴
	5. floor : 주어진 실수값에서 가장 작은 정수값을 리턴
	6. power : 주어진 값 주어진 승수 제곱 power (3,3) 3의 3제곱 
	7. rownum : 오라클에서만 사용되는 속성으로 모든 객체에 제공된다.
					 -- rownum은 전체열 즉, *와 함께 사용할 수 없다.
					 -- rownum은 행번호를 위미
	
	*/
	
-- round(실수, 반올림위치)
select 976.235
     , round(976.235)
		 , round(976.235, 0)
		 , round(976.235, 1)
		 , round(976.235, 2)
		 , round(976.235, -1)
		 , round(976.235, -2)
  from dual;
	
-- trunc(실수, 버림위치)
select 976.235
     , trunc(976.235)
		 , trunc(976.235, 0)
		 , trunc(976.235, 1)
		 , trunc(976.235, 2)
		 , trunc(976.235, -1)
		 , trunc(976.235, -2)
  from dual;
	
-- mod, ceil, floor 
select 121
     , mod(121, 10)
		 , ceil(121.1)
		 , floor(121.9)
  from dual;
	
-- power
select '2의 3승 = ', power(2, 3) from dual union all
select '3의 3승 = ', power(3, 3) from dual; 

-- rownum
select rownum * from student; -- 에러 = rownum * 함께 사용 못함 
select rownum, name from student;
select rownum, name, id from student where deptno1 = 101;

	
	
/*

	C. 날짜 함수
	
	1. sysdate : 시스템의 현재 일자 : 날짜형으로 리턴
	2. months_between : 두 날짜 사이의 개월수 리턴 : 숫자형으로 리턴
	3. add_months : 주어진 일자에 개월수를 더한 결과를 리턴 : 날쩌형으로 리턴
	4. next_day : 주어진 일자 다음 날짜를 리턴 : 날짜형
	5. last_day : 주어진 일자에 해당하는 월의 마지막일자를 리턴
	6. round : 주어진 날짜를 반올림
	7. trunc : 주어진 날짜를 버림
	
*/
	
select sysdate from dual;

-- months_between
select months_between(sysdate, '20190101') from dual;

-- 근속월수
select months_between(sysdate, hiredate) from emp;
	
-- add_months
select sysdate
		 , add_months(sysdate, 2)
		 , add_months(sysdate, -3)
  from dual;
	
-- next_day (현재일에서 다음의 요일)
select sysdate
		 , next_day(sysdate, 1) -- 1 ~ 7 : 일요일 ~ 토요일
		 , next_day(sysdate, 2)
		 , next_day(sysdate, 3)
		 , next_day(sysdate, 4)
		 , next_day(sysdate, 5)
		 , next_day(sysdate, 6)
		 , next_day(sysdate, 7) -- 1:일요일 ~ 7:토요일
  from dual;
	
-- last_day
select sysdate
     , last_day(sysdate)
		 , last_day('20230301')	-- 자동 형 변환
		 , last_day('2023-03-01')
		 , last_day('2023.03.01')
		 , last_day('2023/03/01')
--	 , last_day('2023-MAR-01') -- 에러 
  from dual;
	
-- round / trunc
select sysdate
     , round(sysdate)
		 , trunc(sysdate)
		 , round('20230301')
		 , trunc('20230331')	
  from dual;
	
/*

  형 변환 함수
	
	1. to_char() : 날짜 또는 숫자를 문자로 변환
	2. to_number() : 문자형 숫자를 숫자로 변환 (단, 숫자 형식에 맞아야함)
  3. to_date() : 문자형을 날짜로 변환 (단, 날짜 형식에 맞아야함)
 
*/

-- 1. 자동 형 변환 / 수동 형 변환

-- 1) 자동(묵시적) 형 변환
select '2' + 2 from dual -- 4
union all
select 2 + '2' from dual; -- 문자와 숫자의 연산 => 우선순위는 숫자에 있음.
	
-- 2) 수동(명시적) 형 변환
select to_number('2') + 2 from dual
union all
select 2 + to_number('2') from dual;

select '2a' + 2 from dual; -- 에러
select 'A' + 2 from dual; -- 에러


-- 2. to_char()

-- 1) 날짜를 문자로 변환
select sysdate
     , to_char(sysdate)
		 , to_char(sysdate, 'YYYY') year
		 , to_char(sysdate, 'RRRR') year
		 , to_char(sysdate, 'YY') year
		 , to_char(sysdate, 'RR') year
		 , to_char(sysdate, 'yy') year
		 , to_char(sysdate, 'YEAR') year
		 , to_char(sysdate, 'year') year
  from dual;
	
select sysdate
     , to_char(sysdate)
		 , to_char(sysdate, 'MM') month
		 , to_char(sysdate, 'MON') month
		 , to_char(sysdate, 'MONTH') month
		 , to_char(sysdate, 'mm') month
		 , to_char(sysdate, 'mon') month
		 , to_char(sysdate, 'month') month
  from dual;
	
select sysdate
     , to_char(sysdate)
		 , to_char(sysdate, 'DD') "date"
		 , to_char(sysdate, 'DAY') "date"
		 , to_char(sysdate, 'DDTH') "date"
		 , to_char(sysdate, 'dd') "date"
		 , to_char(sysdate, 'day') "date"
		 , to_char(sysdate, 'ddth') "date"
  from dual;
	
select sysdate
     , to_char(sysdate)
		 , to_char(sysdate, 'YYYY.MM.DD')
     , to_char(sysdate, 'yyyy.mm.dd')
		 , to_char(sysdate, 'yyyy.mm.dd hh:mi')
		 , to_char(sysdate, 'yyyy.mm.dd hh:mi:ss')
		 , to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss')
		 , to_char(sysdate, 'MON.DD.YY hh:mi:ss')
 from dual;
 
-- 2) 숫자를 문자로 변환
-- 12345 => 12,345 or 12345.00 형태로 변환
select 1234
     , to_char(1234, '9999')
		 , to_char(1234, '9999999999')
		 , to_char(1234, '0999999999')
		 , to_char(1234, '$9999')
		 , to_char(1234, '$9999.99')
		 , to_char(1234, '9,999')
		 , to_char(123456789, '9,999,999,999')
  from dual;
	
	
	
	
	/* 연습문제 */

-- ex01) emp테이블에서 ename, hiredate, 근속년, 근속월, 근속일수 출력, deptno = 10;
-- months_between, round, turnc, 개월수계산(/12), 일수계산(/365, /12)
select * from emp;

select ename, hiredate
     , trunc(((sysdate - hiredate) + 1) / 365) 근속년
		 , trunc(months_between(sysdate, hiredate)) 근속월
		 , trunc((sysdate - hiredate) + 1) 근속일수
  from emp
 where deptno = 10;

-- ex02) student에서 birthday중 생일 1월의 학생의 이름과 생일을 출력(YYYY-MM-DD)
select * from student;

select name, birthday
  from student
 where substr(jumin, 3, 2) = 01;
 
select name, birthday
  from student 
 where to_char(birthday, 'mm') = 01;
 
-- ex03) emp에서 hiredate가 1,2,3월인 사람들의 사번, 이름, 입사일을 출력
select * from emp;

select empno, ename, hiredate
  from emp
 where to_number(to_char(hiredate, 'mm')) >= 1 and
 to_number(to_char(hiredate, 'mm')) <= 3;

-- ex04) emp 테이블을 조회하여 이름이 'ALLEN' 인 사원의 사번과 이름과 연봉을 
--       출력하세요. 단 연봉은 (sal * 12)+comm 로 계산하고 천 단위 구분기호로 표시하세요.
--       7499 ALLEN 1600 300 19,500
select * from emp;
select empno, ename, sal
     , to_char(sal * 12 + comm, '99,999')
  from emp
 where ename = 'ALLEN';


-- ex05) professor 테이블을 조회하여 201 번 학과에 근무하는 교수들의 이름과 
--       급여, 보너스, 연봉을 아래와 같이 출력하세요. 단 연봉은 (pay*12)+bonus
--       로 계산합니다.
--       name pay bonus 6,970
select * from professor;

select name, pay, nvl(bonus, 0)
     , to_char(to_number(pay*12+nvl(bonus, 0)), '9,999')
  from professor
 where deptno = 201;

-- ex06) emp 테이블을 조회하여 comm 값을 가지고 있는 사람들의 empno , ename , hiredate ,
--       총연봉,15% 인상 후 연봉을 아래 화면처럼 출력하세요. 단 총연봉은 (sal*12)+comm 으로 계산하고 
--       15% 인상한 값은 총연봉의 15% 인상 값입니다.
--      (HIREDATE 컬럼의 날짜 형식과 SAL 컬럼 , 15% UP 컬럼의 $ 표시와 , 기호 나오게 하세요)
	
select * from emp;
select empno, ename, hiredate
		 , to_char(to_number(sal * 12 + comm), '99,999') 연봉
		 , to_char(to_number((sal * 12 + comm) * 1.15), '99,999') "15% 인상" 
  from emp
 where comm >= 0;
	
	
	
	
	
	
/*

  E. 기타 함수
	
	1. nvl() : null 값을 다른 값으로 치환하는 함수 
	           nvl(comm, 0)
						 
	2. nvl2() : null 값을 다른 값으로 치환하는 함수
	            nvl2(comm, true / false)
							
	3. decode() : 오라클에서만 사용하는 함수 if~else 
	
	4. case : decode 대신 일반적으로 사용되는 문장
	          case 조건 when 결과1 then 출력1,
										 when 결과2 then 출력2,
										 when 결과n then 출력n,
							end as 별칭
*/
	
select sal, nvl(comm, 0), sal - nvl(comm, 0) from emp;


-- nvl()
select name, pay, bonus
		 , pay + bonus as total
		 , nvl(bonus, 0)
		 , to_char(pay + nvl(bonus, 0)) 
  from professor
 where deptno = 201;
 
 
 -- nvl2(col, !null, null)

select name, pay, bonus
     , nvl2(bonus, bonus, 0)
		 , nvl2(bonus, pay+bonus, pay) as 총급여
	from professor
 where deptno = 201;

select ename, sal, comm
		 , sal + nvl(comm, 0)
		 , sal + nvl(comm, 100)
		 , nvl2(comm, 'not value null', 'value null')
		 , nvl2(comm, 'comm exist', ename || ' theres no comm')
  from emp;
	
	
-- ex01) professor 테이블에서 201번 학과 교수들의 이름과 급여, bonus, 총 연봉 출력.
		  -- 총 연봉은 (pay*12+bonus) 로 계산하고 bonus가 없는 교수는 0으로 계산
select * from professor;			

select name, pay, bonus
     , to_char(pay * 12 + nvl(bonus, 0), '9,999') 연봉
  from professor
 where deptno = 201;
 
 select name, pay, bonus
      , to_char(nvl2(bonus, pay*12+bonus, pay*12), '9,999') 연봉
  from professor
 where deptno = 201;

-- ex02) 아래 화면과 같이 emp 테이블에서 deptno가 30번인 사원들을 조회하여 comm 값이 있을 경우
      -- 'Exist'를 출력하고 comm 값이 null 일 경우 'NULL' 을 출력.
	
select * from emp;

select ename, comm
		 , nvl2(comm, 'Exist', 'NULL') "comm E/N"
  from emp
 where deptno = 30;
 
 
-- decode 함수
-- 통상적으로 if~else문을 decode로 표한한 함수로 오라클에서만 사용.
-- 오라클에서 자주 사용하는 중요한 함수
-- decode(col, true, false) 즉, col결과(값)이 true일 경우 true 실행문 실행, 
																		--  	 false일 경우 false 실행문 실행
-- decode(deptno, 101, true,
--                102, true,
--                103, true, false) => if~else if~else

-- decode(deptno, 101 decode()...) 중첩 if문

-- 101 => 컴퓨터공학, 아니면 기타학과
select name, deptno
     , decode(deptno, 101, '컴퓨터공학과') 학과-- if(true) {} 
		 , decode(deptno, 101, '컴퓨터공학과', '기타학과') 학과-- if(true) {} else {}
  from professor;


select * from department;
-- 101 컴공, 102 미디어융합, 103 소프트공학, 나머지는 기타학과
select name, deptno
     , decode(deptno, 101, '컴퓨터공학과' -- if(true) {} 
		                , 102, '미디어융합'
										, 103, '소프트공학'
										, '기타학과') -- if(true) {} else if {} else if {}
  from professor;
	
-- 중첩 decode
-- 101 학과 교수 중 Audie Murphy 교수는 'Best Professor' 아니면 'Good', 101 이외 학과 교수는 N/A

select * from professor;

select name, deptno
     , decode(deptno, 101, 'Best Professor', 'N/A')
		 , decode(name, 'Audie Murphy', 'Best Professor', 'Good')
		 , decode(deptno, 101, decode(name, 'Audie Murphy', 'Best Professor', 'Good'), 'N/A')
 from professor;
 
 
 -- student 에서 전공 101 학생들 중 jumin 성별 구분해서 1 or 3 = 남자, 2 or 4 = 여자
 -- name, jumin, gender / substr, decode
 
select * from student;
 
select name, jumin
		  , decode(substr(jumin,7, 1), 1, '남자'
			                           , 3, '남자'
																 , 2, '여자'
																 , 4, '여자') gender
   from student;
 
 -- student 테이블에서 1전공이 deptno1 - 101 학생의 이름과 연락처 지여을 출력
 -- 지역번호 02 - SEOUL, 031 - GYEONGGI, 051 - BUSAN 052 - ULSAN, 055 - GYEONGNAM
 -- substr, instr, decode
 
select * from student;
 
select name, tel from student;
 
 select name, tel
		  , decode(substr(tel, 1, instr(tel, ')')-1)
			                          , 02, 'SEOUL'
															  , 031, 'GYEONGGI'
															  , 051, 'BUSAN'
																, 052, 'ULSAN'
																, 055, 'GYEONGNAM'
																, '기타') as REGION
   from student
  where deptno1 = 101
		          
							
-- case 문
-- 1) case 조건 when 결과 then 출력..

select name, tel							
					     , case substr(tel, 1, instr(tel, ')', 1)-1)		
							      when '02' then '서울'		
										when '031' then '경기'		
										when '051' then '부산'		
										when '052' then '울산'		
										when '055' then '경남'
										else '기타'
								end as 지역					
   from student
  where deptno1 = 101;
	
-- 2) case when between 값1 and 값2 then 출력..
-- emp 테이블에서 sal 1-1000 1등급, 1001~2000 2등급, ... 4001 ^ 5등급
select ename, sal
		 , case when sal between 1 and 1000 then '1등급'
		        when sal between 1001 and 2000 then '2등급'
						when sal between 2001 and 3000 then '3등급'
						when sal between 3001 and 4000 then '4등급'
						when sal > 4001 then '5등급'
				end as 등급
	 from emp;
	 
	 
-- ex01) student에서 jumin에 월참조해서 해당월이 분기를 출력
--       (1Q, 2Q, 3Q, 4Q) name, jumin, 분기

select * from student;

select name, jumin
		 , substr(jumin, 3, 2)
		 , case when substr(jumin, 3, 2) between '01' and '03' then '1Q'
		        when substr(jumin, 3, 2) between '04' and '06' then '2Q'
						when substr(jumin, 3, 2) between '07' and '09' then '3Q'
						when substr(jumin, 3, 2) between '10' and '12' then '4Q'
				end as 분기
  from student;


-- ex02) dept에서 10=회계부, 20=연구부, 30=영업부, 40=전산실 (decode / case)
--       deptno, 부서명

select * from dept;
-- decode
select dname, deptno
     , decode(deptno, 10, '회계부'
		                , 20, '연구부'
									  , 30, '영업부'
										, 40, '전산실'
										, '기타') as DNAME
  from dept;

-- case
select dname, deptno
		 , case deptno
		   when 10 then '회계부'
			 when 20 then '연구부'
			 when 30 then '영업부'
			 when 40 then '전산실'
	 end as DNAME
  from dept;

-- ex03) 급여인상률 다르게 적용하기
--       emp에서 sal < 1000  0.8인상, 1000~2000  0.5인상, 2001~3000  0.3인상
--       그 이상은 0.1인상 / 인상분 출력 
--       ename, sal(인상 전 급여), 인상 후 급여 (decode / case)
--       sign() : 값이 음수 양수 결과를 -1 0 1 로 리턴

select * from emp;
-- decode
select ename, sal "sal before"
		 , decode(sign(sal-1000), 
		                -1, sal * 1.08, 
										 0, sal * 1.08, 
										 1, decode(sign(sal-2000), 
										   -1, sal * 1.05, 
										    0, sal * 1.05, 
									    	1, decode(sign(sal-3000), 
										      -1, sal * 1.03, 
									      	 0, sal * 1.03, 
										       1, sal * 1.01))) as "sal after"
					from emp;

-- case 
 select ename, sal "sal before"
      , case when sal <= 1000 then sal * 1.08
						 when sal >= 1001 and sal <= 2000 then sal * 1.05
						 when sal >= 2001 and sal <= 3000 then sal * 1.03
						 when sal > 3000 then sal * 1.01
				end as "sal after"
			from emp;


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	