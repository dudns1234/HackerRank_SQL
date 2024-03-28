# SELECT 문제 풀이

-- 3월에 태어난 여성 회원 목록
-- 조건 : 생일 = 3월, 성별 = w, 전화번호 =! NULL

SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_FORMAT(DATE_OF_BIRTH,"%Y-%m-%d") DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO IS NOT NULL AND DATE_FORMAT(DATE_OF_BIRTH,"%m") ='03' AND GENDER = "W"
ORDER BY MEMBER_ID

DATE_FORMAT(____,'%Y-%m-%d'), IS NOT NULL

-- 재구매가 일어난 상품과 회원 리스트 구하기
-- 조건 : '동일한 회원'이 '동일한 상품' 재구매 -> COUNT(*) >= 2
-- 정렬 : 회원ID 오름차순 -> 상품ID 내림차순
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC

-- 오프라인/온라인 판매 데이터 통합하기
-- 조건/정렬
-- 2022년 3월의 오프라인/온라인 상품 판매
-- OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL
-- 판매일 오름차순 -> 상품ID 오름차순 -> 유저ID 오름차순
--> INNER, LEFT JOIN 아님 UNION ALL 로 써야함.
SELECT DATE_FORMAT(SALES_DATE,"%Y-%m-%d") SALES_DATE,PRODUCT_ID,USER_ID,SALES_AMOUNT FROM ONLINE_SALE WHERE DATE_FORMAT(SALES_DATE,"%Y-%m") = "2022-03"
UNION ALL
SELECT DATE_FORMAT(SALES_DATE,"%Y-%m-%d") SALES_DATE,PRODUCT_ID,NULL USER_ID,SALES_AMOUNT FROM OFFLINE_SALE WHERE DATE_FORMAT(SALES_DATE,"%Y-%m") = "2022-03"
ORDER BY SALES_DATE,PRODUCT_ID,USER_ID

-- 아픈 동물 찾기
-- 조건, 정렬: = Sick, 아이디순 오름차순
SELECT ANIMAL_ID,NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = "Sick"
ORDER BY ANIMAL_ID

-- 어린 동물 찾기
-- 조건, 정렬: != 'Aged', 아이디순 오름차순
SELECT ANIMAL_ID,NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION != 'Aged'
-- WHERE NOT INTAKE_CONDITION LIKE 'AGED'
ORDER BY ANIMAL_ID

-- 동물의 아이디와 이름
-- 조건, 정렬: 모든 동물, ANIMAL_ID 오름차순
SELECT ANIMAL_ID,NAME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- 여러 기준으로 정렬하기
-- 조건, 정렬: 모든 동물, NAME 오름차순, 보호를 나중에 시작
SELECT ANIMAL_ID,NAME,DATETIME
FROM ANIMAL_INS
ORDER BY NAME, DATETIME DESC

-- 상위 N개 레코드
-- 조건: 가장 먼저 들어온 동물의 이름
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME LIMIT 1

-- 조건에 맞는 회원수 구하기
-- 조건: 2021년에 가입, 회원나이 20이상 29이하
SELECT COUNT(*) USERS
FROM USER_INFO
WHERE LEFT(JOINED,4) = '2021' AND AGE >= 20 AND AGE <= 29
-- WHERE DATE_FORMAT(JOINED,'%Y') = '2021' AND AGE BETWEEN 20 AND 29

-- 가장 큰 물고기 10마리 구하기
SELECT ID,LENGTH
FROM FISH_INFO
ORDER BY LENGTH DESC, ID LIMIT 10

-- 잔챙이 갑은 수 구하기
-- 조건: 길이가 10cm 이하 = LENGTH 가 NULL 
SELECT COUNT(*) FISH_COUNT
FROM FISH_INFO
WHERE LENGTH IS NULL

-- Python 개발자 찾기
-- 조건, 정렬: Python 스킬을 가짐, ID 오름차순
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPER_INFOS
WHERE SKILL_1 = 'Python' OR SKILL_2 = 'Python' OR SKILL_3 = 'Python'
ORDER BY ID

-- 조건에 맞는 개발자 찾기
SELECT ID, EMAIL,FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (SELECT sum(CODE)
                    FROM SKILLCODES
                    WHERE NAME = 'Python' OR NAME = 'C#')
                    -- WHERE NAME IN ('Python','C#'))
ORDER BY ID
# 비트 단위 논리 연산자 (2진법)
& : 비트 단위 AND
| : 비트 단위 OR
SELECT 1&0; //0으로 출력 
SELECT 1&1; //1로 출력 
SELECT 5&7; //5로 출력(101&111=101) 
SELECT 1|1; //1로 출력 
SELECT 1|0; //1로 출력 
SELECT 5|7; // 7로 출력 (101|111=111)

-- 특정 물고기를 잡은 총 수 구하기
-- 조건: 물고기 이름은 BASS, SNAPPER
SELECT COUNT(*) FISH_COUNT
FROM FISH_INFO
WHERE FISH_TYPE IN (SELECT FISH_TYPE
                    FROM FISH_NAME_INFO
                    WHERE FISH_NAME IN ('BASS','SNAPPER'))

# SUM, MAX, MIN 
-- 가장 비싼 상품 구하기
SELECT MAX(PRICE) MAX_PRICE
FROM PRODUCT

-- 가격이 가장 비싼 식품의 정보 출력하기
SELECT *
FROM FOOD_PRODUCT
WHERE PRICE IN (SELECT MAX(PRICE) FROM FOOD_PRODUCT)

-- 최댓값 구하기
SELECT DATETIME '시간'
FROM ANIMAL_INS
ORDER BY DATETIME DESC LIMIT 1

-- 최솟값 구하기
SELECT DATETIME '시간'
FROM ANIMAL_INS
ORDER BY DATETIME LIMIT 1

-- 동물 수 구하기
SELECT COUNT(*)
FROM ANIMAL_INS

-- 중복 제거하기
-- 조건: 이름이 NULL인 경우는 집계하지 않으며, 중복되는 이름 제거
SELECT COUNT(DISTINCT NAME)
FROM ANIMAL_INS
WHERE NAME IS NOT NULL

-- 조건에 맞는 아이템들의 가격의 총합 구하기
SELECT SUM(PRICE) TOTAL_PRICE
FROM ITEM_INFO
WHERE RARITY = 'LEGEND'

-- 잡은 물고기 중 가장 큰 물고기의 길이 구하기
SELECT CONCAT(MAX(LENGTH),'cm') MAX_LENGTH
FROM FISH_INFO

-- 물고기 종류 별 대어 찾기
SELECT A.ID, B.FISH_NAME, A.LENGTH
FROM (
    SELECT FI2.ID, FI.FISH_TYPE, FI.LENGTH	
    FROM (
            SELECT FISH_TYPE, MAX(LENGTH) LENGTH
            FROM FISH_INFO
            GROUP BY FISH_TYPE ) FI, FISH_INFO FI2
    WHERE FI.FISH_TYPE = FI2.FISH_TYPE AND FI.LENGTH = FI2.LENGTH
    )A, FISH_NAME_INFO B
WHERE A.FISH_TYPE = B.FISH_TYPE

# GROUP BY
-- 조건에 맞는 사용자와 총 거래금액 조회하기
SELECT UGU.USER_ID, UGU.NICKNAME, UGB.TOTAL_SALES
FROM (
        SELECT WRITER_ID, SUM(PRICE) TOTAL_SALES
        FROM USED_GOODS_BOARD
        WHERE STATUS = 'DONE'
        GROUP BY WRITER_ID
        HAVING SUM(PRICE) >= 700000
    )UGB, USED_GOODS_USER UGU 
WHERE UGB.WRITER_ID = UGU.USER_ID
ORDER BY UGB.TOTAL_SALES

-- 저자 별 카테고리 별 매출액 집계하기
SELECT BB.AUTHOR_ID, A.AUTHOR_NAME, BB.CATEGORY, BB.TOTAL_SALES
FROM (
        SELECT B.AUTHOR_ID, B.CATEGORY, SUM(BS.SALES * B.PRICE) TOTAL_SALES
        FROM BOOK B INNER JOIN BOOK_SALES BS ON B.BOOK_ID = BS.BOOK_ID 
        WHERE DATE_FORMAT(BS.SALES_DATE,'%Y-%m') = '2022-01'
        GROUP BY B.AUTHOR_ID, B.CATEGORY
     ) BB, AUTHOR A
WHERE BB.AUTHOR_ID = A.AUTHOR_ID
ORDER BY BB.AUTHOR_ID, BB.CATEGORY DESC

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기 ( ~~ LIKE '%값%')
SELECT CAR_TYPE, COUNT(*) CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%' OR OPTIONS LIKE '%열선시트%' OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE

-- 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기 (MONTH 함수, WINDOW함수 사용)
SELECT MONTH(START_DATE) MONTH, CAR_ID, COUNT(*) RECORDS
FROM (
    SELECT	car_id, start_date, COUNT(*) OVER(PARTITION BY CAR_ID) CNT
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE DATE_FORMAT(START_DATE,'%Y-%m') >= '2022-08' AND DATE_FORMAT(START_DATE,'%Y-%m') <= '2022-10'
    ) SUB
WHERE CNT>=5
GROUP BY MONTH, CAR_ID
ORDER BY MONTH, CAR_ID DESC

-- 성분으로 구분한 아이스크림 총 주문량
SELECT I.INGREDIENT_TYPE, SUM(F.TOTAL_ORDER) TOTAL_ORDER
FROM FIRST_HALF F JOIN ICECREAM_INFO I ON F.FLAVOR = I.FLAVOR
GROUP BY I.INGREDIENT_TYPE
ORDER BY TOTAL_ORDER

-- 즐겨찾기가 가장 많은 식당 정보 출력
SELECT FOOD_TYPE, REST_ID,REST_NAME,FAVORITES
FROM (
    SELECT FOOD_TYPE, REST_ID,REST_NAME,FAVORITES,
       MAX(FAVORITES) OVER(PARTITION BY FOOD_TYPE) MAX_FAV
    FROM REST_INFO
     ) SUB
WHERE FAVORITES = MAX_FAV
ORDER BY FOOD_TYPE DESC

-- 카테고리 별 도서 판매량 집계하기
SELECT CATEGORY, SUM(SALES) TOTAL_SALES
FROM BOOK B JOIN BOOK_SALES BS ON B.BOOK_ID = BS.BOOK_ID
WHERE DATE_FORMAT(SALES_DATE,'%Y-%m')='2022-01'
GROUP BY  CATEGORY
ORDER BY CATEGORY

-- 자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기
SELECT CAR_ID,
        CASE
            WHEN CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY WHERE START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16') THEN '대여중'
            ELSE '대여 가능'
        END AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC

-- 진료과별 총 예약 횟수 출력하기
SELECT MCDP_CD, COUNT(*) '5월예약건수'
FROM APPOINTMENT 
WHERE DATE_FORMAT(APNT_YMD,'%Y-%m') = '2022-05'
GROUP BY MCDP_CD
ORDER BY 2,1

-- 식품분류별 가장 비싼 식품의 정보 조회하기
SELECT CATEGORY,PRICE MAX_PRICE,PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE PRICE IN (
                SELECT MAX(PRICE)
                FROM FOOD_PRODUCT
                GROUP BY CATEGORY
                )
    AND CATEGORY IN ('과자', '국', '김치', '식용유')
ORDER BY PRICE DESC

-- 고양이와 개는 몇 마리 있을까
SELECT ANIMAL_TYPE, COUNT(*) count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE

-- 동명 동물 수 찾기
SELECT NAME, COUNT(*) COUNT
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT(*) >= 2
ORDER BY NAME

-- 년, 월, 성별 별 상품 구매 회원 수 구하기 (DISTINCT 사용)
-- 왜? 월별 통계를 계산할 때, 동일 유저가 2일에 걸쳐 구매한 경우도 1로 카운트 해야하기 때문
SELECT YEAR(SALES_DATE) YEAR ,MONTH(SALES_DATE) MONTH,GENDER, COUNT(DISTINCT UI.USER_ID) USERS
FROM USER_INFO UI JOIN ONLINE_SALE OS ON UI.USER_ID = OS.USER_ID
WHERE GENDER IS NOT NULL
GROUP BY YEAR(SALES_DATE), MONTH(SALES_DATE), GENDER
ORDER BY 1,2,3

-- 입양 시각 구하기(1)(HOUR 사용)
SELECT HOUR(DATETIME) HOUR, COUNT(*) COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) BETWEEN 9 AND 19
GROUP BY HOUR(DATETIME)
ORDER BY 1

-- 입양 시각 구하기(2)(WITH RECURSIVE 사용)
WITH RECURSIVE TEMP AS(
    SELECT 0 AS HOUR
    UNION ALL
    SELECT HOUR + 1 FROM TEMP
    WHERE HOUR < 23
)

SELECT T.HOUR, COUNT(HOUR(AO.DATETIME)) COUNT -- COUNT(*) 이렇게 하면 0이 아닌 1로 나와서 안됨.
FROM TEMP T LEFT JOIN ANIMAL_OUTS AO ON T.HOUR = HOUR(AO.DATETIME)
GROUP BY T.HOUR
ORDER BY 1

-- 가격대 별 상품 개수 구하기
SELECT CASE
            WHEN PRICE BETWEEN 10000 AND 19999 THEN 10000
            WHEN PRICE BETWEEN 20000 AND 29999 THEN 20000
            WHEN PRICE BETWEEN 30000 AND 39999 THEN 30000
            WHEN PRICE BETWEEN 40000 AND 49999 THEN 40000
            WHEN PRICE BETWEEN 50000 AND 59999 THEN 50000
            WHEN PRICE BETWEEN 60000 AND 69999 THEN 60000
            WHEN PRICE BETWEEN 70000 AND 79999 THEN 70000
            WHEN PRICE BETWEEN 80000 AND 89999 THEN 80000
            ELSE 0
        END PRICE_GROUP,
        COUNT(*)   
FROM PRODUCT
GROUP BY 1
ORDER BY 1

-- 조건에 맞는 사원 정보 조회하기
SELECT SCORE,A.EMP_NO,EMP_NAME,POSITION,EMAIL
FROM (
        SELECT EMP_NO,
                SUM(SCORE) OVER(PARTITION BY EMP_NO) SCORE
        FROM HR_GRADE
        WHERE YEAR = '2022'
    ) A, HR_EMPLOYEES B
WHERE A.EMP_NO = B.EMP_NO
ORDER BY SCORE DESC LIMIT 1

-- 연간 평가점수에 해당하는 평가 등급 및 성과금 조회하기 (문제 이상 - 평균필요)
SELECT HE.EMP_NO, EMP_NAME, 
        CASE
             WHEN AVG(SCORE) >= 96 THEN 'S'
             WHEN AVG(SCORE) >= 90 THEN 'A'
             WHEN AVG(SCORE) >= 80 THEN 'B'
             ELSE 'C' END AS GRADE,
       SAL * CASE
                WHEN AVG(SCORE) >= 96 THEN 0.2
                WHEN AVG(SCORE) >= 90 THEN 0.15
                WHEN AVG(SCORE) >= 80 THEN 0.1
                ELSE 0 END AS BONUS
FROM HR_GRADE HG, HR_EMPLOYEES HE
WHERE HG.EMP_NO = HE.EMP_NO
GROUP BY EMP_NO
ORDER BY 1

-- 부서별 평균 연봉 조회하기
SELECT HD.DEPT_ID, DEPT_NAME_EN, ROUND(AVG(SAL)) AVG_SAL
FROM HR_DEPARTMENT HD JOIN HR_EMPLOYEES HE ON HD.DEPT_ID = HE.DEPT_ID
GROUP BY HD.DEPT_ID
ORDER BY AVG_SAL DESC

-- 물고기 종류 별 잡은 수 구하기
SELECT COUNT(*) FISH_COUNT, FISH_NAME
FROM FISH_INFO FI JOIN FISH_NAME_INFO FNI ON FI.FISH_TYPE = FNI.FISH_TYPE
GROUP BY FISH_NAME
ORDER BY 1 DESC

-- 월별 잡은 물고기 수 구하기
SELECT COUNT(*) FISH_COUNT, MONTH(TIME) MONTH
FROM FISH_INFO 
GROUP BY MONTH(TIME)
ORDER BY 2

-- 노선별 평균 역 사이 거리 조회하기
SELECT ROUTE, CONCAT(ROUND(SUM(D_BETWEEN_DIST),1),'km') TOTAL_DISTANCE, CONCAT(ROUND(AVG(D_BETWEEN_DIST),2),'km') AVERAGE_DISTANCE	
FROM SUBWAY_DISTANCE 
GROUP BY ROUTE
ORDER BY 2 DESC

-- 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기
SELECT COUNT(*) FISH_COUNT, MAX(LENGTH)	MAX_LENGTH,	FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING AVG(IFNULL(LENGTH, 10)) >= 33
ORDER BY 3

-- 언어별 개발자 분류하기
SELECT GRADE, ID, EMAIL
FROM(
    SELECT 
        CASE
            WHEN SKILL_CODE & (SELECT sum(CODE) FROM SKILLCODES WHERE CATEGORY = "Front End") AND SKILL_CODE & (SELECT sum(CODE) FROM SKILLCODES WHERE NAME = "Python") THEN 'A'
            WHEN SKILL_CODE & (SELECT sum(CODE)
                                FROM SKILLCODES
                                WHERE NAME = 'C#') THEN 'B'
            WHEN SKILL_CODE & (SELECT sum(CODE)
                                FROM SKILLCODES
                                WHERE CATEGORY = "Front End") THEN 'C'
            END GRADE, ID, EMAIL
    FROM DEVELOPERS
    ) A
WHERE GRADE IS NOT NULL
ORDER BY 1, 2

# IS NULL
-- 경기도에 위치한 식품창고 목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN,'N') FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE LEFT(ADDRESS,3) = '경기도'
ORDER BY 1

-- 이름이 없는 동물의 아이디
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL
ORDER BY 1

-- 이름이 있는 동물의 아이디
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY 1

-- NULL 처리하기
SELECT ANIMAL_TYPE, IFNULL(NAME,'No name') NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS

-- 나이 정보가 없는 회원 수 구하기
SELECT COUNT(*) USERS
FROM USER_INFO
WHERE AGE IS NULL

-- ROOT 아이템 구하기
SELECT ITEM_ID,ITEM_NAME	
FROM ITEM_INFO
WHERE ITEM_ID IN (
                    SELECT ITEM_ID
                    FROM ITEM_TREE 
                    WHERE PARENT_ITEM_ID IS NULL
                )
ORDER BY 1

-- 업그레이드 할 수 없는 아이템 구하기
SELECT ITEM_ID, ITEM_NAME, RARITY
FROM ITEM_INFO
WHERE ITEM_ID NOT IN (SELECT DISTINCT PARENT_ITEM_ID
                    FROM ITEM_TREE
                    WHERE PARENT_ITEM_ID IS NOT NULL
                    )
ORDER BY 1 DESC

-- 잡은 물고기의 평균 길이 구하기
SELECT ROUND(AVG(IFNULL(LENGTH,10)),2) AVERAGE_LENGTH
FROM FISH_INFO 

# 주문량이 많은 아이스크림들 조회하기
SELECT FLAVOR
FROM(
    SELECT F.FLAVOR, (SUM(F.TOTAL_ORDER) + SUM(J.TOTAL_ORDER)) AS TOTAL
    FROM FIRST_HALF F, JULY J 
    WHERE F.FLAVOR = J.FLAVOR
    GROUP BY F.FLAVOR
    ORDER BY TOTAL DESC LIMIT 3
    ) A

-- 특정 기간동안 대여 가능한 자동차들의 대여비용 구하기
--  조건1. 자동차 종류가 '세단' 또는 'SUV' 인 자동차 중 (OK)
# SELECT *
# FROM CAR_RENTAL_COMPANY_CAR 
# WHERE CAR_TYPE IN ('세단','SUV')

# -- 조건2. 2022년 11월 1일부터 2022년 11월 30일까지 대여 가능하고 (HELL...) => 즉, START_DATE와 END_DATE 11월 HISTORY 불가능
# SELECT DISTINCT CAR_ID
# FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
# WHERE CAR_ID NOT IN (
#                 SELECT CAR_ID
#                 FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
#                 WHERE START_DATE <= '2022-11-01' AND END_DATE >= '2022-11-01' --   ("2022-11-01" between START_DATE and END_DATE) or ("2022-11-31" between START_DATE and END_DATE))
#                 )
-- 조건3. 30일간의 대여 금액이 50만원 이상 200만원 미만
# SELECT *, ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) FEE -- CH.CAR_ID, CC.CAR_TYPE, ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) FEE
# FROM (SELECT * FROM CAR_RENTAL_COMPANY_CAR WHERE CAR_TYPE IN ('세단','SUV')) CC JOIN
#      (SELECT * FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN WHERE DURATION_TYPE = '30일 이상') CP ON CC.CAR_TYPE = CP.CAR_TYPE
# WHERE ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) BETWEEN 500000 AND 1999999

-- 정렬.대여 금액을 기준으로 내림차순 정렬하고, 자동차 종류를 기준으로 오름차순 정렬, 자동차 ID를 기준으로 내림차순 정렬
# ORDER BY 3 DESC, 2, 1 DESC

-- 출력.자동차 ID, 자동차 종류, 대여 금액(컬럼명: FEE) 리스트를 출력
# SELECT CC.CAR_ID, CC.CAR_TYPE, ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) FEE
SELECT CC.CAR_ID, CC.CAR_TYPE, ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) FEE
FROM (SELECT * FROM CAR_RENTAL_COMPANY_CAR WHERE CAR_TYPE IN ('세단','SUV')) CC,
     (SELECT * FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN WHERE DURATION_TYPE = '30일 이상') CP,
     (SELECT DISTINCT CAR_ID
      FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
      WHERE CAR_ID NOT IN (SELECT CAR_ID
                           FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
                           WHERE START_DATE <= '2022-11-01' AND END_DATE >= '2022-11-01')) CH 
WHERE CC.CAR_TYPE = CP.CAR_TYPE AND CC.CAR_ID = CH.CAR_ID AND ROUND(DAILY_FEE * 30*(1-DISCOUNT_RATE/100)) BETWEEN 500000 AND 1999999
ORDER BY 3 DESC, 2, 1 DESC

-- 5월 식품들의 총매출 조회하기
SELECT FP.PRODUCT_ID, PRODUCT_NAME, SUM(PRICE*AMOUNT) TOTAL_SALES
FROM FOOD_PRODUCT FP, (SELECT *
                        FROM FOOD_ORDER
                        WHERE DATE_FORMAT(PRODUCE_DATE,'%Y-%m') = '2022-05') FO
WHERE FP.PRODUCT_ID = FO.PRODUCT_ID
GROUP BY FP.PRODUCT_ID
ORDER BY 3 DESC, 1

-- 조건에 맞는 도서와 저자 리스트 출력하기
SELECT B.BOOK_ID, AUTHOR_NAME, DATE_FORMAT(PUBLISHED_DATE,'%Y-%m-%d') PUBLISHED_DATE
FROM BOOK B JOIN AUTHOR A USING(AUTHOR_ID)
WHERE  CATEGORY = '경제'
ORDER BY 3

-- 그룹별 조건에 맞는 식당 목록 출력하기
SELECT MEMBER_NAME,REVIEW_TEXT,DATE_FORMAT(REVIEW_DATE,'%Y-%m-%d')REVIEW_DATE
FROM MEMBER_PROFILE  M JOIN (SELECT *, COUNT(*) OVER(PARTITION BY MEMBER_ID) CNT FROM REST_REVIEW) R USING (MEMBER_ID)
WHERE CNT = (SELECT MAX(CNT) FROM (SELECT *, COUNT(*) OVER(PARTITION BY MEMBER_ID) CNT FROM REST_REVIEW) R)
ORDER BY 3,2

-- 없어진 기록 찾기
SELECT ANIMAL_ID, AO.NAME
FROM ANIMAL_OUTS AO LEFT JOIN ANIMAL_INS AI USING(ANIMAL_ID)
WHERE AI.ANIMAL_ID IS NULL
ORDER BY 1

-- 있었는데요 없었습니다.
SELECT I.ANIMAL_ID, I.NAME
FROM ANIMAL_INS I JOIN ANIMAL_OUTS O USING(ANIMAL_ID)
WHERE I.DATETIME > O.DATETIME
ORDER BY I.DATETIME

-- 오랜 기간 보호한 동물(1)
SELECT I.NAME, I.DATETIME
FROM ANIMAL_INS I LEFT JOIN ANIMAL_OUTS O USING(ANIMAL_ID)
WHERE O.ANIMAL_ID IS NULL
ORDER BY DATETIME LIMIT 3

-- 보호소에서 중성화한 동물
SELECT AI.ANIMAL_ID, AI.ANIMAL_TYPE, AI.NAME
FROM ANIMAL_INS AI, ANIMAL_OUTS AO
WHERE AI.ANIMAL_ID = AO.ANIMAL_ID AND AI.SEX_UPON_INTAKE != AO.SEX_UPON_OUTCOME
ORDER BY ANIMAL_ID

-- 상품 별 오프라인 매출 구하기
SELECT PRODUCT_CODE	, SUM(PRICE*SALES_AMOUNT) SALES
FROM PRODUCT JOIN OFFLINE_SALE USING(PRODUCT_ID)
GROUP BY PRODUCT_CODE
ORDER BY 2 DESC, 1

-- 상품을 구매한 회원 비율 구하기
-- 2021년에 가입한 전체 회원들 중 
WITH TEMP AS(
    SELECT *
    FROM USER_INFO 
    WHERE YEAR(JOINED) = '2021'
)

# SELECT * FROM TEMP

# INNER JOIN하게 되면 USER_ID 중복 생김 (하나의 ID로 여러개 구매했기 때문에)
# SELECT *
# FROM ONLINE_SALE O JOIN TEMP T USING(USER_ID)
# ORDER BY USER_ID

# -- 상품을 구매한 회원의 비율(=2021년에 가입한 회원 중 상품을 구매한 회원수 / 2021년에 가입한 전체 회원 수)을 년, 월 별로 출력
SELECT YEAR(SALES_DATE) YEAR,
       MONTH(SALES_DATE) MONTH,
       COUNT(DISTINCT T.USER_ID) PUCHASED_USERS,
       ROUND(COUNT(DISTINCT USER_ID)/(SELECT COUNT(*) FROM USER_INFO WHERE YEAR(JOINED) = '2021'),1) PUCHASED_RATIO
FROM ONLINE_SALE O JOIN TEMP T USING(USER_ID)
GROUP BY 1,2
ORDER BY 1,2

-- FrontEnd 개발자 찾기
SELECT ID, EMAIL,FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (SELECT SUM(CODE)
                    FROM SKILLCODES 
                    WHERE CATEGORY = 'Front End')
ORDER BY 1

# String, Date
-- 조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기
SELECT CONCAT('/home/grep/src/',BOARD_ID,'/',FILE_ID,FILE_NAME,FILE_EXT) FILE_PATH
FROM USED_GOODS_FILE
WHERE BOARD_ID =  (SELECT BOARD_ID FROM USED_GOODS_BOARD ORDER BY VIEWS DESC LIMIT 1)
ORDER BY FILE_ID DESC

-- 특정 옵션이 포함된 자동차 리스트 구하기
SELECT *
FROM CAR_RENTAL_COMPANY_CAR 
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY 1 DESC

-- 자동차 대여 기록 별 대여 금액 구하기 (다시 풀어보기)
WITH TEMP AS (
                SELECT *
                FROM CAR_RENTAL_COMPANY_CAR C JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H USING(CAR_ID)
                WHERE CAR_TYPE = '트럭'
)

SELECT HISTORY_ID, IF(DURATION IS NULL, ROUND((DATEDIFF(END_DATE,START_DATE)+1) * DAILY_FEE),  ROUND(DAILY_FEE * (DATEDIFF(END_DATE,START_DATE)+1) *(1-DISCOUNT_RATE/100))) FEE
FROM
    (SELECT * , CASE
                    WHEN DATEDIFF(END_DATE,START_DATE) >= 90 THEN '90일 이상'
                    WHEN DATEDIFF(END_DATE,START_DATE) BETWEEN 30 AND 89 THEN '30일 이상'
                    WHEN DATEDIFF(END_DATE,START_DATE) BETWEEN 7 AND 29 THEN '7일 이상'
                    ELSE NULL
                END  DURATION
    FROM TEMP) T LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P ON T.CAR_TYPE = P.CAR_TYPE AND T.DURATION = P.DURATION_TYPE
GROUP BY HISTORY_ID
ORDER BY 2 DESC, 1 DESC

-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID,WRITER_ID,TITLE,PRICE, CASE
                                          WHEN STATUS = 'SALE' THEN "판매중"
                                          WHEN STATUS = 'RESERVED' THEN "예약중"
                                          WHEN STATUS = 'DONE' THEN "거래완료"
                                        END STATUS
FROM USED_GOODS_BOARD
WHERE DATE_FORMAT(CREATED_DATE,'%Y-%m-%d') = '2022-10-05'
ORDER BY 1 DESC

-- 조건별로 분류하여 주문상태 출력하기
SELECT ORDER_ID,PRODUCT_ID, DATE_FORMAT(OUT_DATE,'%Y-%m-%d') OUT_DATE,CASE
                                                                         WHEN DATE_FORMAT(OUT_DATE,'%m-%d') <= '05-01' THEN '출고완료'
                                                                         WHEN DATE_FORMAT(OUT_DATE,'%m-%d') > '05-01' THEN '출고대기'
                                                                         ELSE '출고미정'
                                                                      END '출고여부'
FROM FOOD_ORDER
ORDER BY 1

-- 조건에 맞는 사용자 정보 조회하기(SUBSTRING)
SELECT U.USER_ID, NICKNAME, CONCAT(CITY,' ',STREET_ADDRESS1,' ',STREET_ADDRESS2)'전체주소',CONCAT(LEFT(TLNO,3),'-',SUBSTRING(TLNO,4,4),'-',RIGHT(TLNO,4)) '전화번호' 
FROM USED_GOODS_BOARD B, USED_GOODS_USER U
WHERE B.WRITER_ID = U.USER_ID
GROUP BY WRITER_ID
HAVING COUNT(*) >= 3
ORDER BY 1 DESC

-- 대여 기록이 존재하는 자동차 리스트 구하기
SELECT DISTINCT CAR_ID
FROM CAR_RENTAL_COMPANY_CAR JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY USING(CAR_ID)
WHERE CAR_TYPE = '세단' AND MONTH(START_DATE) = 10
ORDER BY 1 DESC

-- 자동차 대여 기록에서 장기/단기 대여 구분하기
SELECT HISTORY_ID,CAR_ID,DATE_FORMAT(START_DATE,'%Y-%m-%d')START_DATE,DATE_FORMAT(END_DATE,'%Y-%m-%d')END_DATE,IF(DATEDIFF(END_DATE,START_DATE)+1>=30,'장기 대여','단기 대여') RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
WHERE DATE_FORMAT(START_DATE,'%Y-%m') = '2022-09'
ORDER BY 1 DESC

-- 자동차 평균 대여 기간 구하기
SELECT CAR_ID, ROUND(AVG(DATEDIFF(END_DATE,START_DATE)+1),1) AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
GROUP BY CAR_ID
HAVING AVG(DATEDIFF(END_DATE,START_DATE)+1) >= 7
ORDER BY 2 DESC, 1 DESC

-- 취소되지 않은 진료 예약 조회하기
SELECT APNT_NO, PT_NAME, P.PT_NO, D.MCDP_CD, DR_NAME, APNT_YMD
FROM APPOINTMENT A JOIN PATIENT P USING(PT_NO) JOIN DOCTOR D
WHERE APNT_CNCL_YN = 'N' AND DATE_FORMAT(APNT_YMD,'%Y-%m-%d')='2022-04-13' AND  A.MCDP_CD = 'CS' AND A.MDDR_ID = D.DR_ID
ORDER BY APNT_YMD

-- 루시와 엘라 찾기
SELECT ANIMAL_ID,NAME,SEX_UPON_INTAKE
FROM ANIMAL_INS
WHERE NAME IN ('Lucy','Ella','Pickle','Rogan','Sabrina','Mitty')
ORDER BY 1

-- 이름에 el이 들어가는 동물 찾기
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE ANIMAL_TYPE = 'Dog' AND NAME LIKE '%EL%'
ORDER BY 2

-- 중성화 여부 파악하기
SELECT ANIMAL_ID, NAME, CASE
                            WHEN SEX_UPON_INTAKE LIKE 'NEUTERED%' OR SEX_UPON_INTAKE LIKE 'SPAYED%' THEN 'O'
                            ELSE 'X'
                        END '중성화'
FROM ANIMAL_INS

-- 오랜 기간 보호한 동물(2)
SELECT ANIMAL_ID, I.NAME
FROM ANIMAL_OUTS O JOIN ANIMAL_INS I USING(ANIMAL_ID)
ORDER BY DATEDIFF(O.DATETIME,I.DATETIME) DESC LIMIT 2

-- DATETIME에서 DATE로 형 변환
SELECT ANIMAL_ID,NAME,DATE_FORMAT(DATETIME,'%Y-%m-%d') '날짜'
FROM ANIMAL_INS

-- 카테고리 별 상품 개수 구하기
SELECT LEFT(PRODUCT_CODE,2) CATEGORY, COUNT(*) PRODUCTS
FROM PRODUCT
GROUP BY 1

-- 연도 별 평균 미세먼지 농도 조회하기
SELECT YEAR(YM) YEAR, ROUND(AVG(PM_VAL1),2) 'PM10', ROUND(AVG(PM_VAL2),2) 'PM2.5'
FROM AIR_POLLUTION
WHERE LOCATION2 = '수원'
GROUP BY YEAR(YM)
ORDER BY 1


-- 한 해에 잡은 물고기 수 구하기
SELECT COUNT(*) FISH_COUNT
FROM FISH_INFO
WHERE LEFT(TIME,4) = '2021'

-- 분기별 분화된 대장균의 개체 수 구하기
WITH TEMP AS(
    SELECT *, CASE
                WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 1 AND 3 THEN CONCAT(1,'Q')
                WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 4 AND 6 THEN CONCAT(2,'Q')
                WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 7 AND 9 THEN CONCAT(3,'Q')
                WHEN MONTH(DIFFERENTIATION_DATE) BETWEEN 10 AND 12 THEN CONCAT(4,'Q')
            END QUARTER
    FROM ECOLI_DATA
)

SELECT QUARTER, COUNT(*) ECOLI_COUNT
FROM TEMP
GROUP BY QUARTER
ORDER BY 1

# 추가 문제 풀기
-- 대장균의 크기에 따라 분류하기 1
SELECT ID, CASE
                WHEN SIZE_OF_COLONY <= 100 THEN 'LOW'
                WHEN SIZE_OF_COLONY > 100 AND SIZE_OF_COLONY <= 1000 THEN 'MEDIUM'
                WHEN SIZE_OF_COLONY > 1000 THEN 'HIGH'
            END SIZE
FROM ECOLI_DATA
ORDER BY 1

-- 대장균들의 자식의 수 구하기
WITH TEMP AS(
    SELECT PARENT_ID, COUNT(*) CHILD_COUNT
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NOT NULL
    GROUP BY PARENT_ID
)

SELECT ID, IFNULL(CHILD_COUNT,0) CHILD_COUNT
FROM ECOLI_DATA E LEFT JOIN TEMP T ON E.ID = T.PARENT_ID
ORDER BY 1

-- 연도별 대장균 크기의 편차 구하기
WITH TEMP AS (
    SELECT YEAR(DIFFERENTIATION_DATE) YEAR,SIZE_OF_COLONY, MAX(SIZE_OF_COLONY) OVER(PARTITION BY YEAR(DIFFERENTIATION_DATE)) MAX_SIZE,ID
    FROM ECOLI_DATA
)

SELECT YEAR, (MAX_SIZE-SIZE_OF_COLONY) YEAR_DEV, ID
FROM TEMP
ORDER BY 1,2