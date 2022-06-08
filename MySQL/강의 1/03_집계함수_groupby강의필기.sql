use hr;

/* **************************************************************************
집계(Aggregation) 함수와 GROUP BY, HAVING
************************************************************************** */

/* ******************************************************************************************
집계함수, 그룹함수, 다중행 함수
- 인수(argument)는 컬럼.
  - sum(): 전체합계
  - avg(): 평균
  - min(): 최소값
  - max(): 최대값
  - stddev(): 표준편차. 편차의 평균
  - variance(): 분산
  - count(): 개수
        - 인수: 
            - 컬럼명: null을 제외한 값들의 개수.
            -  *: 총 행수 - null과 관계 없이 센다.
	   - count(distinct 컬럼명): 고유값의 개수.
  
- count(*) 를 제외한 모든 집계함수들은 null을 제외하고 집계한다. 
	- (avg, stddev, variance는 주의)  100개 중 60개만 값이 있다면 60개의 합계/60  이다.  
								=> 전체 데이터에 대한 평균이 아니라 값이 있는 것들의 평균이 되는 것.
    
	-avg(), variance(), stddev()은 전체 개수가 아니라 null을 제외한 값들의 평균, 분산, 표준편차값이 된다.=>avg(ifnull(컬럼, 0))
- 문자타입/일시타입: max(), min(), count()에만 사용가능
	- 문자열 컬럼의 max(): 사전식 배열에서 가장 마지막 문자열, min()은 첫번째 문자열. 
	- 일시타입 컬럼은 오래된 값일 수록 작은 값이다.

******************************************************************************************* */

-- EMP 테이블에서 급여(salary)의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 총직원수를 조회 


-- EMP 테이블에서 가장 최근 입사일(hire_date)과 가장 오래된 입사일을 조회



-- EMP 테이블의 부서(dept_name) 의 개수를 조회


-- emp 테이블에서 job 종류의 개수 조회



-- TODO:  커미션 비율(comm_pct)이 있는 직원의 수를 조회


-- TODO: 커미션 비율(comm_pct)이 없는 직원의 수를 조회


-- TODO: 가장 큰 커미션비율(comm_pct)과 과 가장 적은 커미션비율을 조회


-- TODO:  커미션 비율(comm_pct)의 평균을 조회. 소수점 이하 2자리까지 출력


-- TODO: 직원 이름(emp_name) 중 사전식으로 정렬할때 가장 나중에 위치할 이름을 조회.


-- TODO: 급여(salary)에서 최고 급여액과 최저 급여액의 차액을 출력


-- TODO: 가장 긴 이름(emp_name)이 몇글자 인지 조회.


-- TODO: EMP 테이블의 업무(job) 종류가 몇개 있는 조회. 고유값들의 개수


-- TODO: EMP 테이블의 부서(dept_name)가 몇종류가 있는지 조회. 고유값들의 개수



/* **************
group by 절
- 특정 컬럼(들)의 값별로 행들을 나누어 집계할 때 기준컬럼을 지정하는 구문.
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균
- 구문: group by 컬럼명 [, 컬럼명]
	- 컬럼: 범주형 컬럼을 사용 - 부서별 급여 평균, 성별 급여 합계
	- select의 where 절 다음에 기술한다.
	- select 절에는 group by 에서 선언한 컬럼들만 집계함수와 같이 올 수 있다.
	
****************/

-- 업무(job)별 급여의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 직원수를 조회

-- 입사연도 별 직원들의 급여 평균.


-- 부서명(dept_name) 이 'Sales'이거나 'Purchasing' 인 직원들의 업무별 (job) 직원수를 조회


-- 부서(dept_name), 업무(job) 별 최대, 평균급여(salary)를 조회.


-- 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.


-- TODO: 부서별(dept_name) 직원수를 조회
select ifnull(dept_name,'부서미배치') "dept_name", count(*) from emp
group by dept_name;

-- TODO: 업무별(job) 직원수를 조회. 직원수가 많은 것부터 정렬.
select ifnull(dept_name,'부서미배치') "dept_name", count(*) from emp
group by dept_name
order by 2 desc;


-- TODO: 부서명(dept_name)별 업무(job)별 직원수, 최고급여(salary)를 조회. 부서이름으로 오름차순 정렬.
select ifnull(dept_name,'부서미배치'), job, count(*) "직원수", max(salary) "최고급여"
from emp
group by dept_name, job
order by 1;

-- TODO: EMP 테이블에서 입사연도별(hire_date) 총 급여(salary)의 합계을 조회. 
-- (급여 합계는 정수부에 자리구분자 , 를 넣고 $를 붙이시오. ex: $2,000,000)
select year(hire_date)"입사 년도", concat('$', format(sum(salary),0))"급여 합계"
from emp
group by 1
order by 1;
-- TODO: 같은해 입사해서 같은 업무를 한 직원들의 평균 급여(salary)을 조회
select year(hire_date)"입사 년도", job, avg(salary) "평균 급여"
from emp
group by 1,2
order by 1, 2;

-- TODO: 부서별(dept_name) 직원수 조회하는데 부서명(dept_name)이 null인 것은 제외하고 조회.
select dept_name, count(*)
from emp
where dept_name is not null
group by dept_name;

use hr;
-- TODO 급여 범위별 직원수를 출력. 급여 범위는 5000 미만, 5000이상 10000 미만, 10000이상 20000미만, 20000이상. 
-- case 문 이용
select case when salary<5000 then '4등급' when salary between 5000 and 9999 then '3등급' when salary between 10000 and 19999  then '2등급' else '1등급' end, count(*)
from emp
group by 1;


/*
select 컬럼 정의
from 테이블 정의
where 행을 설정 조건에 따라
group by 어떻게 그룹 묶을 것 [with rullup]
having 집계 처리 결과에 관한 조건에 따라 행을
order by 어떻게 정렬할 것인가?
=> 실행되는 순서가 있다. from절 where절 group절 having절 select절 order절
*/
-- 조회를 하고 그룹으로 나눈다고 생각하며 안된다.
-- emp 테이블을 들고와, 년도 별로 그룹으로 나누고, 그룹별 값 조건 비교해서 맞는 거 남기고, 얘를 들을 가지고 select에서 조회하는 것.

                      
/* **************************************************************
having 절
- 집계결과에 대한 행 제약 조건
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  -- 연산자는 where절의 연산자를 사용한다. 피연산자는 집계함수(의 결과)
    
    
************************************************************** */

-- 직원수가 10 이상인 부서의 부서명(dept_name)과 직원수를 조회
select dept_name, count(*) -- 5. 조건 만족 열에 대해 조회 처리
from emp -- 1 테이블 찾고
group by dept_name -- 3 그룹 묶고
having count(*) >= 10; -- 4 조건 맞는 집계 결과 true  열 찾고

-- 직원수가 10명 이상인 부서의 부서명과 직원들의 급여 평균
select dept_name, avg(salary)
from emp
group by dept_name
having count(*) >= 10;


-- TODO: 20명 이상이 '입사한 년도'와 (그 해에) 입사한 직원수를 조회.
select year(hire_date), count(*)
from emp
group by 1
having count(*) >=20;


-- TODO: 10명 이상의 직원이 담당하는 '업무(job)명'과 담당 직원수를 조회
select job, count(*) "담당 직원수"
from emp
group by 1
having count(*)>= 10;

-- TODO: 평균 급여가(salary) $5000 이상인 '부서'의 이름(dept_name)과 평균 급여(salary), 직원수를 조회
select dept_name, avg(salary) "평균 급여", count(*) "직원수"
from emp
group by dept_name
having avg(salary)>= 5000
order by 1;

-- TODO: 평균 급여가(salary) $5000 이상인 부서의 이름(dept_name)과 직원수를 조회
-- 조건에 들어가는 컬럼이 꼭 select에 들어가는 게 아님.
select dept_name, count(*) "직원수"
from emp
group by dept_name
having avg(salary)>= 5000
order by 1;

-- TODO: 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
select dept_name, avg(salary) "평균 급여", sum(salary) "총 급여"
from emp
group by dept_name
having avg(salary)>=5000 and sum(salary)>=50000;

-- TODO 직원이 2명 이상인 부서들의 이름과 급여의 표준편차를 조회
select dept_name, avg(salary) "평균 급여", stddev(salary) "급여 표준편차"
from emp
group by dept_name
having count(*) >= 2;


/* ***************************************************************************************
# with rollup : group by 뒤에 붙인다.
 - group by로 묶어 집계할 때 총계나 중간 집계(group by 컬럼이 여러개일경우) 를 계산한다.
 - 구문 : group by 컬럼명[, .. ] with rollup
 - ex) group by job with rollup
 -- 그룹바이가 없는 상태에서의 처리 결과. 합계면 분류 전 전체 행 합계. 평균이면 분류 전 전체 행 평균.
   -> 소분류를 빼고 대분류를 했을 때 집계. 대분류까지빼고 그룹바이 안했을 때 처럼 총 집계.

 
 
# grouping(컬럼명 [, 컬럼명]) : select 절에서 사용.
- group by  컬럼명 with rollup 으로 집계했을 때 grouping(컬럼명)의 컬럼이 집계시 값들을 그룹으로 나누는데 사용되었으면 0 사용되지 않았으면 1을 반환한다. 
  1이 반환 된 경우는 그 행의 결과는 총계이거나 중간소계임을 말한다.
  이게 해당 그룹으로 묶인 처리 결과 행이냐, 안 묶인 처리 결과 행이냐.

  
- grouping(컬럼1, 컬럼2, 컬럼3) 과 같이 여러개 컬럼을 지정한 경우
	집계에 모든 세개의 컬럼이 다 사용되었으면 0
    앞의 두개만 사용되었으면 1
    앞의 한개만 사용되었으면 3
    세개 다 사용되지 않았으면 7
    
    컬럼1      컬럼2       컬럼3
     2**2  +  2**1    +  2**0      각각 참여하면 0, 참여 안하면 1을 곱해서 더한다.
     4*참여여부 + 2*참여여부 +1*참여여부(0,1)
    - 2 번 예제 처럼 풀면 되서 이 방법 알아만 두기


* ***************************************************************************************/

-- EMP 테이블에서 업무(job)별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.

select job, avg(salary) "평균급여"
from emp
group by job with rollup ;

-- EMP 테이블에서 업무(job)별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회. 
-- grouping(job) job이 그룹으로 묶인 컴럼인지, 그룹으로 묶인 행의 총계인지
select grouping(job), avg(salary) "평균급여"
from emp
group by job with rollup ;

-- EMP 테이블에서 부서(dept)별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.
select if(grouping(dept_name) =1, '총계', dept_name) , avg(salary) "평균급여" 
from emp
group by dept_name with rollup -- group by 없는 처럼. select avg(salary) from emp; 이 출력값같이 전체 행 급여 평균도 출력 되는 것.
order by 1;

select if(grouping(dept_name)=1, '총계', ifnull(dept_name,'부서미배치')), count(*)
from emp
group by dept_name with rollup
order by 1;


-- 2 EMP 테이블에서 부서(dept_name), 업무(job) 별 salary의 합계와 직원수를 소계와 총계가 나오도록 조회
-- dept_name 중 job의 집계. -> 소분류를 빼고 대분류를 했을 때 집계. 대분류까지빼고 그룹바이 안했을 때 처럼 총 집계.

select if (grouping(dept_name)=1,'총계', dept_name) "dept_name", 
	   if (grouping(job)=1, '소계', job) "job",
       sum(salary) "급여합계",
       count(*) "직원수"
from emp
group by dept_name, job with rollup;

  -- grouping에 여러 컬럼 넣어 푼 방법.
select grouping(dept_name, job), count(*)
from emp
group by dept_name, job with rollup;
-- (dept_name이 1번 컬럼  2**1 =2) * 0 + (job이 2번 컬럼 2**0 = 1) * 0 = 0  ==> dept_name, job 집계
-- (dept_name이 1번 컬럼  2**1 =2) * 0 + (job이 2번 컬럼 2**0 = 1) * 1 = 1  => 소집계
-- (dept_name이 1번 컬럼  2**1 =2) * 1 + (job이 2번 컬럼 2**0 = 1) * 1 = 3  => 총계



-- # 총계/소계 행의 경우 :  총계는 '총계', 중간집계는 '소계' 로 출력
-- TODO: 부서별(dept_name) 별 최대 salary와 최소 salary를 조회
select if(grouping(dept_name), "총계", dept_name), max(salary) "최대 봉급", min(salary) "최소 봉급"
from emp
group by dept_name with rollup;


-- TODO: 상사_id(mgr_id) 별 직원의 수와 총계를 조회하시오.
select if(grouping (mgr_id),"총계",mgr_id) "mgr_id", count(*) "직원수"
from emp
group by mgr_id with rollup;


-- TODO: 입사연도(hire_date의 year)별 직원들의 수와 연봉 합계 그리고 총계가 같이 출력되도록 조회.
select if (grouping (year(hire_date)), "총계", hire_date) "dept_name", count(*), sum(salary)
from emp
group by year(hire_date) with rollup;


-- TODO: 부서(dept_name), 입사년도별 평균 급여(salary) 조회. 부서별 집계와 총집계가 같이 나오도록 조회
select if (grouping(dept_name), "총집계", ifnull(dept_name,"부서미배치")) "dept_name",
       if (grouping (year(hire_date)), "부서별 집계", year(hire_date)) "입사 년도", avg(salary) "평균 급여"
from emp
group by dept_name, year(hire_date) with rollup;

