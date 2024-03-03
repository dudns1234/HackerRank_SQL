-- 중위수 구하기
SELECT ROUND(AVG(LAT_N),4)
FROM
    (SELECT LAT_N,
            ROW_NUMBER() OVER( ORDER BY LAT_N ) AS RN,
            COUNT(*)  OVER () N
    FROM STATION) RNT
WHERE
    CASE WHEN MOD(N,2) = 1 THEN RN = (N+1)/2
    ELSE RN IN (N/2,(N/2)+1)
    END