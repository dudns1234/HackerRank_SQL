-- 조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기 (핵심 : CONCAT)
SELECT CONCAT('/home/grep/src/',F.BOARD_ID,'/',F.FILE_ID,F.FILE_NAME,F.FILE_EXT) AS FILE_PATH
FROM USED_GOODS_BOARD B, USED_GOODS_FILE F
WHERE B.VIEWS = (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD) AND B.BOARD_ID = F.BOARD_ID
ORDER BY F.FILE_ID DESC;

-- 조건에 맞는 사용자 정보 조회하기(핵심 : CONCAT 함수 - 문자열 붙이기, 전화번호 형식 :000-0000-0000)
SELECT USER_ID,
       NICKNAME,
       CONCAT(CITY, " ", STREET_ADDRESS1, " ", STREET_ADDRESS2) AS 전체주소,
       CONCAT(SUBSTRING(TLNO from 1 for 3), '-' ,SUBSTRING(TLNO from 4 for 4), '-' ,SUBSTRING(TLNO from 8 for 4)) AS 전화번호
FROM USED_GOODS_USER U
WHERE USER_ID in (SELECT WRITER_ID 
                  FROM USED_GOODS_BOARD
                  GROUP BY WRITER_ID
                  HAVING COUNT(BOARD_ID) >= 3 )
ORDER BY USER_ID DESC

-- 조건에 맞는 사용자와 총 거래금액 조회하기 (핵심 : GROUP BY - SUM 집계함수
SELECT U.USER_ID, U.NICKNAME, B.PRI TOTAL_SALES
FROM USED_GOODS_USER U, (SELECT WRITER_ID, SUM(PRICE) PRI
                         FROM  USED_GOODS_BOARD 
                         WHERE STATUS = "DONE"
                         GROUP BY WRITER_ID
                         HAVING SUM(PRICE)>=700000) B
WHERE U.USER_ID = B.WRITER_ID
ORDER BY TOTAL_SALES ASC

-- 오랜 기간 보호한 동물(2) (핵심 : LIMIT 함수)
SELECT O.ANIMAL_ID, O.NAME
FROM ANIMAL_OUTS O, ANIMAL_INS I
WHERE O.ANIMAL_ID = I.ANIMAL_ID
ORDER BY DATEDIFF(O.DATETIME, I.DATETIME) DESC LIMIT 2

-- 대여 기록이 존재하는 자동차 리스트 구하기 (핵심 : MONTH함수)
SELECT DISTINCT CAR_ID
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE MONTH(START_DATE)=10 AND CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_CAR WHERE CAR_TYPE='세단')
ORDER BY CAR_ID DESC -- 날짜를 굳이 SPLIT할 필요 없고 YEAR,MONTH,DAY 함수 쓰면됨

-- 자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기 (핵심 : IF문, CASE문, GROUP BY)
## CASE문
SELECT CAR_ID,
CASE
    WHEN CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY WHERE START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16') THEN '대여중'
    ELSE '대여 가능'
END AS AVILABILITY 
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC;
## IF문 
SELECT CAR_ID,
 IF(CAR_ID IN (SELECT CAR_ID FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY WHERE START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16'), '대여중', '대여 가능') AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC;

-- 카테고리 별 도서 판매량 집계하기
SELECT B.CATEGORY, SUM(S.SALES) TOTAL_SALES
FROM BOOK B, BOOK_SALES S
WHERE B.BOOK_ID = S.BOOK_ID AND DATE_FORMAT(S.SALES_DATE,'%Y-%m') = '2022-01'
GROUP BY B.CATEGORY
ORDER BY B.CATEGORY ASC

-- 즐겨찾기가 가장 많은 식당 정보 출력하기
-- 음식종류별로 즐겨찾기 수가 가장 많은 식당의 음식 종류, ID, 식당 이름, 즐겨찾기수 출력!!
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
FROM REST_INFO
WHERE FAVORITES IN (SELECT MAX(FAVORITES) FROM REST_INFO GROUP BY FOOD_TYPE)
GROUP BY FOOD_TYPE  -- 한 번 더 그룹화 필요
ORDER BY FOOD_TYPE DESC

SELECT a.FOOD_TYPE, a.REST_ID, a.REST_NAME, a.FAVORITES
FROM REST_INFO a JOIN (SELECT FOOD_TYPE, max(FAVORITES) AS max_fav
                       FROM REST_INFO  
                       GROUP BY FOOD_TYPE) b
                 ON a.FOOD_TYPE = b.FOOD_TYPE
AND a.FAVORITES = b.max_fav 
ORDER BY FOOD_TYPE desc

-- 조건별로 분류하여 주문상태 출력하기
SELECT ORDER_ID,PRODUCT_ID,DATE_FORMAT(OUT_DATE,'%Y-%m-%d')OUT_DATE, CASE
                                                                        WHEN DATE_FORMAT(OUT_DATE,'%m-%d') <= '05-01' THEN '출고완료'
                                                                        WHEN DATE_FORMAT(OUT_DATE,'%m-%d') > '05-01' THEN '출고대기'
                                                                        ELSE '출고미정'
                                                                     END 출고여부
FROM FOOD_ORDER
ORDER BY ORDER_ID

-- 헤비 유저가 소유한 장소
SELECT ID, NAME, HOST_ID
FROM PLACES
WHERE HOST_ID IN (SELECT HOST_ID FROM PLACES GROUP BY HOST_ID HAVING COUNT(NAME) >= 2)
ORDER BY ID

-- 오랜 기간 보호한 동물(1)
SELECT AI.NAME, AI.DATETIME
FROM ANIMAL_INS AI LEFT JOIN ANIMAL_OUTS AO ON AI.ANIMAL_ID = AO.ANIMAL_ID
WHERE AO.DATETIME IS NULL
ORDER BY DATETIME LIMIT 3

-- 있었는데요 없었습니다.
SELECT AI.ANIMAL_ID, AI.NAME
FROM ANIMAL_INS AI, ANIMAL_OUTS AO
WHERE AI.ANIMAL_ID = AO.ANIMAL_ID AND AI.DATETIME > AO.DATETIME
ORDER BY AI.DATETIME

-- 없어진 기록 찾기
SELECT AO.ANIMAL_ID, AO.NAME
FROM ANIMAL_OUTS AO LEFT JOIN ANIMAL_INS AI ON AO.ANIMAL_ID = AI.ANIMAL_ID
WHERE AI.ANIMAL_ID IS NULL