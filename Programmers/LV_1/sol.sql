-- 조건에 부합하는 중고거래 댓글 조회하기 (핵심 : DATE_FORMET)
SELECT B.TITLE, R.BOARD_ID, R.REPLY_ID, R.WRITER_ID, R.CONTENTS, DATE_FORMAT(R.CREATED_DATE, '%Y-%m-%d')
FROM (SELECT * FROM USED_GOODS_BOARD WHERE CREATED_DATE >= "2022-10-01" AND CREATED_DATE <= "2022-10-31") B, USED_GOODS_REPLY R
WHERE B.BOARD_ID = R.BOARD_ID
ORDER BY R.CREATED_DATE ASC, B.TITLE ASC;

-- 특정 옵션이 포함된 자동차 리스트 구하기 (핵심 : LIKE '%__%')
SELECT CAR_ID, CAR_TYPE, DAILY_FEE, OPTIONS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY CAR_ID DESC

-- 자동차 대여 기록에서 장기/단기 대여 구분하기
SELECT HISTORY_ID, 
CAR_ID, 
DATE_FORMAT(START_DATE,'%Y-%m-%d') START_DATE, 
DATE_FORMAT(END_DATE,'%Y-%m-%d') END_DATE, 
CASE
    WHEN DATEDIFF(END_DATE,START_dATE) +1 >= 30  THEN '장기 대여'  -- DATEDIFF(순,서) 중요
    ELSE '단기 대여'
END AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE DATE_FORMAT(START_DATE, '%Y-%m') = '2022-09' -- WHERE MONTH(START_DATE)=9 도 가능
ORDER BY HISTORY_ID DESC

-- 평균 일일 대여 요금 구하기(핵심 : 평균은 AVG임)
SELECT ROUND(AVG(DAILY_FEE)) AVERAGE_FEE 
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV'

-- 조건에 맞는 도서 리스트 출력하기
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE,'%Y-%m-%d') PUBLISHED_DATE
FROM BOOK
WHERE DATE_FORMAT(PUBLISHED_DATE,'%Y') = '2021' AND CATEGORY = '인문'
ORDER BY PUBLISHED_DATE

-- 과일로 만든 아이스크림 고르기
SELECT FH.FLAVOR
FROM FIRST_HALF FH, ICECREAM_INFO II
WHERE FH.FLAVOR = II.FLAVOR AND FH.TOTAL_ORDER > 3000 AND II.INGREDIENT_TYPE = 'FRUIT_BASED'
ORDER BY INGREDIENT_TYPE

-- 인기있는 아이스크림
SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID

-- 흉부외과 또는 일반외과 의사 목록 출력하기
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD,'%Y-%m-%d') HIRE_YMD
FROM DOCTOR
WHERE MCDP_CD IN ('CS','GS')
ORDER BY HIRE_YMD DESC, DR_NAME

-- 12세 이하인 여자 환자 목록 출력하기(핵심 : IFNULL(Column명, "Null일 경우 대체 값"))
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME 

-- 가장 비싼 상품 구하기
SELECT MAX(PRICE) MAX_PRICE
FROM PRODUCT

-- 조건에 맞는 회원수 구하기
SELECT COUNT(*) USERS
FROM USER_INFO
WHERE DATE_FORMAT(JOINED,'%Y') = '2021' AND AGE BETWEEN 20 AND 29

-- 나이 정보가 없는 회원 수 구하기 (핵심 : 컬럼명 IS NULL => 값 없는 것 찾기)
SELECT COUNT(*) USERS
FROM USER_INFO
WHERE AGE IS NULL

-- 경기도에 위치한 식품창고 목록 출력하기
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN,'N') FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '경기도%'
ORDER BY WAREHOUSE_ID

-- 강원도에 위치한 생산공장 목록 출력하기
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE '강원도%'
ORDER BY FACTORY_ID

-- 최댓값 구하기
SELECT DATETIME 시간
FROM ANIMAL_INS
ORDER BY DATETIME DESC LIMIT 1

-- 이름이 있는 동물의 아이디
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY ANIMAL_ID

-- 상위 N개 레코드
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME LIMIT 1

-- 여러 기준으로 정렬하기
SELECT ANIMAL_ID, NAME, DATETIME
FROM ANIMAL_INS
ORDER BY NAME, DATETIME DESC

-- 동물의 아이디와 이름
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- 이름이 없는 동물의 아이디
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL
ORDER BY ANIMAL_ID

-- 어린 동물 찾기
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION != 'AGED'
ORDER BY ANIMAL_ID

SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE NOT INTAKE_CONDITION LIKE 'AGED'
ORDER BY ANIMAL_ID

-- 아픈 동물 찾기
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'SICK'
ORDER BY ANIMAL_ID

-- 역순 정렬하기
SELECT NAME, DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC

-- 모든 레코드 조회하기
SELECT *
FROM ANIMAL_INS
ORDER BY ANIMAL_ID