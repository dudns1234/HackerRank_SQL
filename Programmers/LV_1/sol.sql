-- 조건에 부합하는 중고거래 댓글 조회하기 (핵심 : DATE_FORMET)
SELECT B.TITLE, R.BOARD_ID, R.REPLY_ID, R.WRITER_ID, R.CONTENTS, DATE_FORMAT(R.CREATED_DATE, '%Y-%m-%d')
FROM (SELECT * FROM USED_GOODS_BOARD WHERE CREATED_DATE >= "2022-10-01" AND CREATED_DATE <= "2022-10-31") B, USED_GOODS_REPLY R
WHERE B.BOARD_ID = R.BOARD_ID
ORDER BY R.CREATED_DATE ASC, B.TITLE ASC;