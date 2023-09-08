/*그룹 함수*/

-- count : 조건에 맞는 행의 갯수를 리턴 
select count(*) from emp;
select count(ename) from emp;
select count(comm) from emp;
select count(nvl(comm, 0)) from emp;
select count(*) from emp where deptno = 10;
select count(sal), count(comm), count(nvl(comm, 0)) from emp;
select count(sal), count(comm), count(nvl(comm, 0)) from emp where comm is not null;

-- sum 
select sum(sal) from emp;
select sum(comm) from emp;
select sum(ename) from emp; -- 에러 = 문자열
select count(ename) 총사원수, 
       sum(sal) 총급여, 
       round(sum(sal)/count(ename), 0) 평균급여 
			 from emp;
			 
-- avg

select count(ename) 총사원수, sum(sal) 총급여, round(sum(sal)/count(ename), 0) 평균급여 
			 from emp
			 
union all
			 
select count(ename) 총사원수, sum(sal) 총급여, round(avg(sal), 0) 평균급여 
			 from emp;

-- min / max
select min(sal + nvl(comm, 0)) 최저급여
     , max(sal + nvl(comm, 0)) 최고급여
  from emp;
	
-- 최초 입사일, 최후 입사일
select min(hiredate) 최초입사일
     , max(hiredate) 최후입사일
	from emp;				
	
-- 이름
select min(ename) 알파벳순빠른이름
     , max(ename) 알파벳순느린이름
  from emp;
	
-- 최초입사자 / 최후입사자
-- 최저급여자 / 최고급여자
select ename from emp
 where hiredate = (select min(hiredate) from emp)
 union all
select ename from emp
 where hiredate = (select max(hiredate) from emp);
 
select ename from emp
 where sal = (select min(sal) from emp)
 union all
select ename from emp
 where sal = (select max(sal) from emp);	

-- 그룹화
-- select 절에 그룹 함수 외 컬럼이나 표현식을 사용할 경우 반드시 group by 절에 선언되어야 함.

-- group by 절에 선언된 컬럼은 select 절에 선언되지 않아도 됨.

-- group by 절에는 반드시 컬럼명 or 표현식이 사용되어야 함. 컬럼의 별칭 사용 불가.

-- group by 절에 사용한 열 기준으로 정렬하기 위해서는 order by 절을 사용하는 경우 
--                                반드시 group by 절 뒤에 선언되어야 함.
-- order by 절에는 컬럼의 순서, 별칭으로도 선언할 수 있음.

select sum(sal) from emp where deptno = 10
union all
select sum(sal) from emp where deptno = 20	
union all		 
select sum(sal) from emp where deptno = 30;


select sum(sal) from emp where deptno = 10;

select deptno, sum(sal) from emp where deptno = 10
group by deptno;

select deptno, sum(sal) from emp group by deptno;

select deptno, sum(sal) from emp group by deptno order by deptno;		 
			 
select deptno, sum(sal) from emp group by deptno order by 1;

select deptno 부서번호, sum(sal) from emp group by deptno order by 부서번호;	 
			 
select deptno 부서번호, sum(sal) from emp group by deptno order by sum(sal) desc;		


-- ex01) 부서 별 사원수, 평균급여, 급여 합계 구하기 - 정렬은 부서번호 deptno 
select deptno, count(*), round(avg(sal)), sum(sal) 
  from emp 
	group by deptno 
	order by deptno;

-- ex02) 직급 별 인원수, 평균급여, 최고급여, 최소급여, 급여합계 정렬은 직급 job
select * from emp;

select job, count(*), round(avg(sal), 0), max(sal), min(sal), sum(sal)
  from emp
 group by job 
 order by 1;
 

-- having 조건절 - 그룹 결과를 조건별로 조회.

-- 단일행 함수에서의 조건절은 where 을 사용하지만 
-- 그룹 함수에서의 조건절은 having 절을 사용.

-- having 절에는 집계함수를 갖고 조건을 비교할 경우 사용되며,
-- having 절과 group by 절은 함께 사용할 수 있음.
-- having 절은 group by 절 없이 사용할 수 없음.

-- 직급별 평균 급여, 직급별 평균급여 3000보다 큰 직급만 조회

select job 직급별
     , count(deptno)
		 , sum(sal) 직급별급여합계
		 , round(avg(sal), 0) 직급별급여평균
		 , max(sal) 최대급여
		 , min(sal) 최소급여
  from emp
 group by job
having round(avg(sal), 0) >= 3000;	

-- ex01) 부서별 직업별 평균급여, 사원수
-- ex02) 부서별      평균급여, 사원수
-- ex03) 총계        평균급여, 사원수

select 부서, 직급, 평균, 사원수
  from (select deptno 부서, job 직급, round(avg(sal), 0) 평균, count(*) 사원수 
        from emp 
        group by deptno, job
 
 union all
 
        select deptno 부서, null, round(avg(sal), 0), count(*) 
        from emp 
        group by deptno
 
 union all
 
        select null, null, round(avg(sal), 0), count(*) 
        from emp) t1
        order by 부서;


-- rollup : 자동으로 소계와 합계를 구해주는 함수
-- group by rollup(deptno, job) -> n+1 개의 그룹 생성
-- 순서에 주의
select deptno
     , job
     , nvl(job, '부서합계')
		 , count(*) 사원수
		 , round(avg(sal + nvl(comm, 0)), 0) 평균급여
  from emp
 group by rollup(deptno, job);

-- professor 테이블에서 deptno, position 별 교수 인원수, 급여 합계 구하기
-- rollup 함수 사용

select * from professor;

select deptno, position
		 , count(*) 인원수
		 , sum(pay) 급여합계
  from professor
 group by rollup(deptno, position);
 
 
 -- cube()
 -- 1. 부서 / 직급 별 사원수 평균 급여
 -- 2. 부서 별 사원수 평균 급여
 -- 3. 직급 별 사원수 평균 급여
 -- 4. 전체 사원수 평균 급여
 
 select deptno, position
		 , count(*) 인원수
		 , sum(pay) 급여합계
  from professor
 group by cube(deptno, position);
 
 select deptno
      , job
			, count(*) 사원수
			, round(avg(sal + nvl(comm, 0)), 2) 평균급여
	 from emp
	group by cube(deptno, job);


/*
 
  순위 함수
	
	1. rank() : 순위 부여, 동일 처리 1,2,2,4
	2. dense_rank() : 순위 부여, 동일 처리 1,2,2,3
	3. row_number() : 행 번호를 제공, 동일 처리 불가
	
	[주의할 점]
	순위 함수는 반드시 order by 절과 함께 사용해야 함

*/

-- rank()
-- 특정 자료별로 순위 : rank(조건값) within group(order by 조건값, 컬럼[asc/desc])
-- 전체 자료 기중 : rank() over(order by 조건값, 컬럼[asc/desc])

-- 특정 조건의 순위
-- SMITH 사원이 알파벳 순으로 몇 번째인지?
select rownum, ename from emp;
select rownum, emp.ename from emp;
select rownum, e.ename from emp e;
select rownum, ename from emp order by ename;

select rownum, ename from (select rownum, ename from emp order by ename) t1;
select rownum, t1.rn, t1.ename from (select rownum as rn, ename from emp order by ename) t1;

select rank('SMITH') within group(order by ename) from emp;
select rank('SMITH') within group(order by ename asc) from emp;
select rank('SMITH') within group(order by ename desc) as "사원명순(후)" from emp;


-- 전체 자료에서의 순위
-- emp에서 각 사원들의 급여순위는?
-- 급여가 작은 순 asc / 급여가 많은 순 desc
select * from emp order by sal;

select ename, sal
     , rank() over(order by sal) -- 급여 적은 순
		 , rank() over(order by sal desc) -- 급여 많은 순
  from emp;
	
-- dense_rank()
select ename, sal
     , rank() over(order by sal) -- 급여 적은 순
		 , dense_rank() over(order by sal) -- 급여 많은 순
  from emp;
	
-- row_number() : 행 번호
select ename, sal
     , rank() over(order by sal) rank -- 급여 적은 순
		 , dense_rank() over(order by sal) dense_rank -- 급여 많은 순
		 , row_number() over(order by sal) row_number
  from emp;
	

/*

  누적 함수
	
	1. sum(컬럼) over(order by 컬럼 [asc/desc]) : 누계(누적)를 구하는 함수
	2. ratio_to_report() : 비율을 구하는 함수

   sum(컬럼) over(partition by 컬럼, order by 컬럼 [asc/desc]) : 누계(누적)를 구하는 함수
*/

-- sum() over()
select * from panmae;
select * from panmae where p_store = 1000 order by 1;

-- 1000번.대리점의 판매일자별 누계액 구하기 
select p_date
		 , p_code
		 , p_qty
		 , p_total
		 , sum(p_total)
  from panmae
 where p_store = 1000 
 group by p_date, p_code, p_qty, p_total
 order by 1;
 
 
 select p_date
		 , p_code
		 , p_qty
		 , p_total
		 , sum(p_total) over(order by p_date) 일자별판몌누계액
  from panmae
 where p_store = 1000 
 order by 1;
 
-- 판매일자별 제품별 판매누계액
select p_date
		 , p_code
		 , p_qty
		 , p_total
		 , sum(p_total) over(order by p_date, p_code) -- 일자별 제품별 판매 누계액
  from panmae
 where p_store = 1000 
 order by 1;
 
 -- 제품별 대리점별 (기준) 누계액
 -- 순서 - 판매일자별
 select p_code
		  , p_store
			, p_date
		  , p_total
		 , sum(p_total) over(partition by p_code, p_store order by p_date)
  from panmae;


-- ratio_to_report
-- 판매 비율
select p_code
		 , p_store
		-- , p_total
		-- , p_qty 
	--	 , sum(p_total) over() 총판매액
	--	 , p_total
		 --, (p_qty / sum(p_qty) over()) * 100
		 , sum(p_qty) over() 총판매수량
		 , round(ratio_to_report(sum(p_qty)) over() * 100, 2) "수량(%)"
		 , p_total
		 , sum(p_total) over() 총판매액
		 , round(ratio_to_report(sum(p_total)) over() * 100, 2) "금액(%)"
  from panmae
	group by p_code, p_qty, p_store, p_total;
	
	
/* 연습문제 */
-- 1. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 
--    가장 적은 경우 , 평균 금액을 구하세요. 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 
--    출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요
-- MAX, MIN, AVG

select * from emp;

select min(sal + nvl(comm, 0)) "최고 급여"
		 , max(sal + nvl(comm, 0)) "최저 급여"
		 , round(avg(sal + nvl(comm, 0)), 1) "평균 급여"
  from emp;


-- 2. student 테이블의 birthday 컬럼을 참조해서 월별로 생일자수를 출력하세요
-- TOTAL, JAN, ...,  5 DEC
--  20EA   3EA ....

select * from student;

select count(*) || ' EA' TOTAL 
     , count(decode(to_char(birthday, 'mm'), '01', 0)) || ' EA' "1월"
		 , count(decode(to_char(birthday, 'mm'), '02', 0)) || ' EA' "2월"
		 , count(decode(to_char(birthday, 'mm'), '03', 0)) || ' EA' "3월"
		 , count(decode(to_char(birthday, 'mm'), '04', 0)) || ' EA' "4월"
		 , count(decode(to_char(birthday, 'mm'), '05', 0)) || ' EA' "5월"
		 , count(decode(to_char(birthday, 'mm'), '06', 0)) || ' EA' "6월"
		 , count(decode(to_char(birthday, 'mm'), '07', 0)) || ' EA' "7월"
		 , count(decode(to_char(birthday, 'mm'), '08', 0)) || ' EA' "8월"
		 , count(decode(to_char(birthday, 'mm'), '09', 0)) || ' EA' "9월"
		 , count(decode(to_char(birthday, 'mm'), '10', 0)) || ' EA' "10월"
		 , count(decode(to_char(birthday, 'mm'), '11', 0)) || ' EA' "11월"
		 , count(decode(to_char(birthday, 'mm'), '12', 0)) || ' EA' "12월"
 from student;

         
-- 3. Student 테이블의 tel 컬럼을 참고하여 아래와 같이 지역별 인원수를 출력하세요.
--    단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM
--    으로 출력하세요

select * from student;

select count(*) "TOTAL"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '02', 0)) "02-SEOUL"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '031', 0)) "031-GYEONGGI"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '051', 0)) "051-BUSAN"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '052', 0)) "052-ULSAN"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '053', 0)) "053-DAEGU"
		 , count(decode(substr(tel, 1, instr(tel, ')')-1), '055', 0)) "055-GYEONGNAM"
 from student;

-- 4. emp 테이블을 사용하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력,
-- 단 급여를 오름차순으로 정렬해서 출력하세요.
-- sum() over()

select * from emp;

select deptno 부서, ename 사원명, sal 급여
     , sum(sal) over(order by sal) 누적
  from emp;


-- 6. student 테이블의 Tel 컬럼을 사용하여 아래와 같이 지역별 인원수와 전체대비 차지하는 비율을 
--    출력하세요.(단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU,055-GYEONGNAM)
       
select * from student;
 
select count(*) || '명(' || (count(name) / count(name) * 100) || '%)' from student;


-- 7. emp 테이블을 사용하여 부서별로 급여 누적 합계가 나오도록 출력하세요. 
-- ( 단 부서번호로 오름차순 출력하세요. )

select * from emp;

select deptno 부서
      , ename 이름
      , sal 급여
			, nvl(comm, 0) 보너스
			, sum(sal + nvl(comm, 0)) 
			  over(partition by deptno order by sal + nvl(comm, 0)) 누적급여
  from emp;


-- 8. emp 테이블을 사용하여 각 사원의 급여액이 전체 직원 급여총액에서 몇 %의 비율을 
--    차지하는지 출력하세요. 단 급여 비중이 높은 사람이 먼저 출력되도록 하세요

select deptno "부서"
     , ename "이름"
		 , sal "급여"
		 , sum(sum(sal)) over() "전체급여"
		 , round(ratio_to_report(sum(sal)) over() * 100, 2) "급여비중(%)"
   from emp
   group by deptno, ename, sal
	 order by 5;

-- 9. emp 테이블을 조회하여 각 직원들의 급여가 해당 부서 합계금액에서 몇 %의 비중을
--     차지하는지를 출력하세요. 단 부서번호를 기준으로 오름차순으로 출력하세요.

select deptno "부서"
		 , ename "이름"
		 , sal "급여"
		 , sum(sum(sal)) over(partition by deptno order by sal) "부서급여합계"
		 , round((ratio_to_report(sum(sal)) over(partition by deptno)) * 100, 2) "부서급여비중%"
  from emp
	group by deptno, ename, sal
	order by 1;
	

	
 


			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 