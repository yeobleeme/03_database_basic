/*

  A. where 조건절
	
	1. 비교연산자
	=,
	!=, <>
	>
	>=
	<
	<=
	
	2. 기타연산자
	a and b : 논리 곱
	a or b : 논리 합
	not a : 부정
	between A and B : a와 b 사이의 데이터를 검색, a는 b 보다 작은 값으로 정의
	in(a, b, c ...) : a, b, c ...의 값을 갖고있는 데이터를 검색
	like (%, _ 와 같이 사용) : 특정 패턴을 갖고있는 데이터를 검색
	    -> '%A' 끝이 A로 끝나는 데이터, 'A%' A로 시작, '%A%' A 문자열을 포함 하는 데이터
  is null/ is not null : null 값 여부의 데이터를 검색
	
	
	*/
	
	
-- A. 비교 연산자
-- 1. 급여 (sal) 5000인 사원 조회하기
select * from emp; 
select * from emp where sal = 5000;
select * from emp where sal = 1600;	

-- 2. 급여 (sal) 900보다 작은 사원
select * from emp where sal < 900;
select * from emp where sal > 900;
select * from emp where sal >= 900;

select * from emp where sal <> 900;
select * from emp where sal != 900;

-- 3. 이름이 smith 인 사원 조회
select * from emp where ename = 'smith'; -- 에러 = 대소문자 구분
select * from emp where ename = 'SMITH';
select * from emp where ename = SMITH; -- 에러 = 열 이름으로 인식

-- 대소문자 변환 함수 upper(), lower()
select * from emp where ename = 'smith';
select ename from emp where ename = upper('smith');
select ename from emp where lower(ename) = 'smith';

-- 4. 입사일자(hiredate)
-- 입사일자 1980-12-17 사원을 조회
-- (hint) date 타입은 비교할 때 문자열로 간주
select * from emp;
select * from emp where hiredate = '1980-12-17';



-- 연습문제 

-- ex01) 급여가 1000 보다 작은 사원만 출력 (ename/sal/hiredate 만 출력)
select ename, sal, hiredate from emp where sal < 1000;


-- ex02) 부서(dept) 테이블에서 부서번호와 부서명을 별칭으로 한 sql문 작성
select * from dept;
select deptno as 부서번호, dname as 부서명 from dept;


-- ex03) 사원 테이블에서 중복 제거 후 직급만 출력
select * from emp;
select distinct job from emp;


-- ex04) 급여가 800 인 사원만 조회
select * from emp where sal = 800;

-- ex05) 사원명이 BLAKE 인 사원만 출력
select * from emp where ename = 'BLAKE';

-- ex06) 사원이름 JAMES-MARTIN 사이의 사원을 사원번호, 사원명, 급여를 출력
--       and / between 두 형태로 작성

select * from emp;
select empno, ename, sal from emp where ename between 'JAMES' and 'MARTIN';

select empno, ename, sal from emp where ename >= 'JAMES' and ename <='MARTIN';







