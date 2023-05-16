/* 연습문제 */
-- 1. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 
--    가장 적은 경우 , 평균 금액을 구하세요. 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 
--    출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요
-- MAX, MIN, AVG
select max(sal + nvl(comm, 0)) 가장_많은_급여
		  ,min(sal+nvl(comm, 0)) 가장_적은_급여
		  ,round(avg(sal + nvl(comm, 0)),1) 평균_급여
  from emp;


-- 2. student 테이블의 birthday 컬럼을 참조해서 월별로 생일자수를 출력하세요
-- TOTAL, JAN, ...,  5 DEC
--  20EA   3EA ....
select count(*) || 'EA' "TOTAL"
			,count(case when substr(jumin, 3, 2) = '01' then 1 end) || 'EA' "JAN"
			,count(case when substr(jumin, 3, 2) = '02' then 1 end) || 'EA' "FEB"
			,count(case when substr(jumin, 3, 2) = '03' then 1 end) || 'EA' "MAR"
			,count(case when substr(jumin, 3, 2) = '04' then 1 end) || 'EA' "APR"
			,count(case when substr(jumin, 3, 2) = '05' then 1 end) || 'EA' "MAY"
			,count(case when substr(jumin, 3, 2) = '06' then 1 end) || 'EA' "JUN"
			,count(case when substr(jumin, 3, 2) = '07' then 1 end) || 'EA' "JUL"
			,count(case when substr(jumin, 3, 2) = '08' then 1 end) || 'EA' "AUG"
			,count(case when substr(jumin, 3, 2) = '09' then 1 end) || 'EA' "SEP"
			,count(case when substr(jumin, 3, 2) = '10' then 1 end) || 'EA' "OCT"
			,count(case when substr(jumin, 3, 2) = '11' then 1 end) || 'EA' "NOV"
			,count(case when substr(jumin, 3, 2) = '12' then 1 end) || 'EA' "DEC"
from student;


-- 3. Student 테이블의 tel 컬럼을 참고하여 아래와 같이 지역별 인원수를 출력하세요.
--    단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM
--    으로 출력하세요
select count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '02' then 1 end) "02-SEOUL"
			,count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '031' then 1 end) "031-GYEONGGI"
			,count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '051' then 1 end) "051-BUSAN"
			,count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '052' then 1 end) "052-ULSAN"
			,count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '053' then 1 end) "053-DAEGU"
			,count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '055' then 1 end) "055-GYEONGNAM"
from student;


-- 4. emp 테이블을 사용하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력,
-- 단 급여를 오름차순으로 정렬해서 출력하세요.
-- sum() over()
select ename, sal, sum(sal) 
  over(order by sal) 누적급여금액 
	from emp order by sal;


-- 6. student 테이블의 Tel 컬럼을 사용하여 아래와 같이 지역별 인원수와 전체대비 차지하는 비율을 
--    출력하세요.(단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU,055-GYEONGNAM)
select * from student;
select count(*) || '명' 전체
     , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '02' then 1 end) || '명' "02-SEOUL"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '02' then 1 end) / count(*) * 100 || '%' SEOUL
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '031' then 1 end) "031-GYEONGGI"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '031' then 1 end) / count(*) * 100 || '%' GYEONGGI
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '051' then 1 end) "051-BUSAN"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '051' then 1 end) / count(*) * 100 || '%' BUSAN
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '052' then 1 end) "052-ULSAN"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '052' then 1 end) / count(*) * 100 || '%' ULSAN
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '053' then 1 end) "053-DAEGU"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '053' then 1 end) / count(*) * 100 || '%' DAEGU
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '055' then 1 end) "055-GYEONGNAM"
		 , count(case when substr(tel, 1, (instr(tel, ')') - 1)) = '055' then 1 end) / count(*) * 100 || '%' GYEONGNAM
 from student;

-- 7. emp 테이블을 사용하여 부서별로 급여 누적 합계가 나오도록 출력하세요. 
-- ( 단 부서번호로 오름차순 출력하세요. )
select distinct(deptno), sum(sal) 
  over(order by deptno) 급여누계 
	from emp order by deptno;

-- 8. emp 테이블을 사용하여 각 사원의 급여액이 전체 직원 급여총액에서 몇 %의 비율을 
--    차지하는지 출력하세요. 단 급여 비중이 높은 사람이 먼저 출력되도록 하세요
select ename
     , sal
	   , round(ratio_to_report(sum(sal)) over() * 100, 2) "급여(%)"
 from emp
group by ename, sal
order by sal desc;

-- 9. emp 테이블을 조회하여 각 직원들의 급여가 해당 부서 합계금액에서 몇 %의 비중을
--     차지하는지를 출력하세요. 단 부서번호를 기준으로 오름차순으로 출력하세요.
select ename
     , deptno
		 , sal
		 , round(ratio_to_report(sum(sal)) 
	over(partition by deptno) * 100, 2) || '%' "부서당 비중"
	from emp group by ename, deptno, sal;
			
			
			
			
			
			
			
			
			
			
			
			