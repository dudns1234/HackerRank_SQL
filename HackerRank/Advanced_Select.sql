-- The PADS
SELECT CASE
           WHEN OCCUPATION = 'SINGER' THEN CONCAT(NAME,'(S)')
           WHEN OCCUPATION = 'Actor' THEN CONCAT(NAME,'(A)')
           WHEN OCCUPATION = 'Doctor' THEN CONCAT(NAME,'(D)')
           WHEN OCCUPATION = 'Professor' THEN CONCAT(NAME,'(P)')
        END OCCUPATION
FROM OCCUPATIONS
ORDER BY NAME;

SELECT concat('There are a total of ',COUNT(*),' ', lower(OCCUPATION),'s.')
FROM OCCUPATIONS
GROUP BY OCCUPATION
ORDER BY COUNT(*), OCCUPATION