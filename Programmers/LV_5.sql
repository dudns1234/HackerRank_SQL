--상품을 구매한 회원 비율 구하기 (생각보다 너무 쉬웠음)
-- 2021년에 가입한 전체 회원들 중
    -- 상품을 구매한 회원수
    -- 상품을 구매한 회원의 비율(2021년에 상품을 구매한 회원수/2021년에 가입한 전체 회원수)
-- 년,월별 그룹화
-- 비율은 소수점 두번째자리에서 반올림
-- 년 오름차순, 월 오름차순

-- 2021년에 가입한 전체 회원수 = 158
-- SELECT COUNT(*) FROM USER_INFO WHERE DATE_FORMAT(JOINED,"%Y")='2021'

-- 2021년에 상품을 구매한 회원수
SELECT YEAR(SALES_DATE) YEAR,
       MONTH(SALES_DATE) MONTH,COUNT(DISTINCT UI.USER_ID) PUCHASED_USERS, -- 2021년에 상품을 구매한 회원수
       ROUND(COUNT(DISTINCT UI.USER_ID) / (SELECT COUNT(*) FROM USER_INFO WHERE DATE_FORMAT(JOINED,"%Y")='2021'),1) PUCHASED_RATIO
FROM (SELECT * FROM USER_INFO WHERE DATE_FORMAT(JOINED,"%Y")='2021') UI, ONLINE_SALE OS
WHERE UI.USER_ID = OS.USER_ID
GROUP BY YEAR(SALES_DATE), MONTH(SALES_DATE)
ORDER BY YEAR, MONTH