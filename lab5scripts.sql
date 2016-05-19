--Script1: List company names and divisions for all interviews that occured between
--January 1, 2006 and August 31, 2006
SELECT 'Script 1:' FROM dual;
SELECT companyname, division
FROM interview
WHERE interviewdate >= to_date('01/01/2006', 'mm/dd/yyyy')
        AND interviewdate <= to_date('08/31/2006', 'mm/dd/yyyy');

--Script2: List the name of the city associated with each interview scheduled for a 200 l co-op position. Alphabetize by city name.
SELECT 'Script 2:' FROM dual;
SELECT city
FROM jobsdev.employer employer
        INNER JOIN interview ON employer.companyname = interview.companyname
WHERE qtrcode = 20061 ORDER BY city ASC;


--Script3: List all quarter codes, companynames, and divisions for interviews with zip codes that
-- begin with 100. Format the column headers to be human readable in mixed case.
COLUMN qtrcode                  HEADING 'Qtr|Code'
COLUMN employer.compnayname     HEADING 'Company Name'
COLUMN employer.division        HEADING 'Division'

SELECT 'Script 3' FROM dual;
SELECT DISTINCT qtrcode, employer.companyname, employer.division
FROM jobsdev.employer employer
        INNER JOIN interview ON employer.companyname = interview.companyname
WHERE zipcode LIKE '100%'
ORDER BY qtrcode ASC;

--Script 4: For each co-op quarter, list the average salary offered.
COLUMN qtrcode                                  HEADING 'QTR'
COLUMN TO_CHAR(AVG(salaryOffered),'99.99')      HEADING 'AVERAGE'

SELECT 'Script 4:' FROM dual;
SELECT qtrcode, TO_CHAR(AVG(salaryoffered),'99.99')
FROM interview
        INNER JOIN jobsdev.employer employer ON employer.companyname = interview
.companyname
GROUP BY qtrcode;
--Script5: Display the company names and fivisions whose minimum number of hours
--offered for an interview equals the lowest minimum number of hours offered for
 all
--interviews.
SELECT 'Script 5' FROM dual;
SELECT companyname, division
FROM interview
WHERE minhrsoffered = (select min(minhrsoffered) from interview);

--Script 6: Display the company names and divisions whose minimum number
--of hours offered is equal to the minimum number of hours desired for the quarter.
SELECT 'Script 6:' FROM dual;
SELECT companyname, division
FROM interview
        INNER JOIN quarter ON interview.qtrcode = quarter.qtrcode
WHERE interview.minhrsoffered = quarter.minhrs;

--Script 7: For each quarter, list the full statename, company name, and divisio
n for
--interviews that are companies and divisions found in the develop's list of emp
loyers,
--in locations that match those desired by the student as indivated in the quart
er
-- table
COLUMN q.qtrcode                                        HEADING 'Qtr|Code'
COLUMN state                                            HEADING 'State'
COLUMN companyname                                      HEADING 'Company Name'
COLUMN division                                         HEADING 'Division'
COLUMN to_char(interviewdate, \'DAY, MM, DD, YYYY\')    HEADING 'Interview Date'

SELECT 'Script 7' FROM dual;
SELECT q.qtrcode, s.description, e.companyname, e.division, to_char(interviewdat
e, 'DAY, MM, DD, YYYY') "Interview Date"
FROM interview i
        INNER JOIN jobsdev.employer e ON i.companyname = e.companyname
        INNER JOIN jobsdev.state s ON e.statecode = s.statecode
        INNER JOIN quarter q ON i.qtrcode = q.qtrcode
WHERE e.statecode = q.location
ORDER BY qtrcode ASC, e.companyname DESC;

--Spript 8: List the minimum salary offered for all interviews scheduled for eac
h quarter.
COLUMN min
SELECT 'Script8: ' FROM dual;
SELECT quarter.qtrcode AS "QTRCO", TO_CHAR(MIN(salaryoffered), '99.99') AS "MIN
OFFER"
FROM interview INNER JOIN quarter ON quarter.qtrcode = interview.qtrcode
GROUP BY quarter.qtrcode;

-- Script 9: : For each city located in the states of New York, Massachusetts, C
onnecticut, or
-- New Jersey, display the companies and divisions that are seeking co-op studen
ts to work
-- less than 40 hours per week. Display the city and statecode as a single colum
n
SELECT 'Script 9' FROM dual;
SELECT city || ',' || s.statecode AS "CITY and STATE", e.companyname AS "COMPANY
", e.division
FROM jobsdev.employer e INNER JOIN jobsdev.state s ON s.statecode = e.statecode
INNER JOIN interview i ON i.companyname = e.companyname
WHERE ((s.statecode LIKE 'NY')
        OR (s.statecode LIKE 'CT')
        OR (s.statecode LIKE 'MA')
        OR (s.statecode LIKE 'NJ'))
AND i.minhrsoffered < 40;
-- Script 10
SELECT 'Script 10' FROM dual;
SELECT city || ',' || s.statecode AS "CITY and STATE", e.companyname AS "COMPANY
", e.division
FROM jobsdev.employer e INNER JOIN jobsdev.state s ON s.statecode = e.statecode
INNER JOIN interview i ON i.companyname = e.companyname
WHERE ((s.statecode LIKE 'NY')
        OR (s.statecode LIKE 'CT')
        OR (s.statecode LIKE 'MA')
        OR (s.statecode LIKE 'NJ'))
AND i.minhrsoffered = 40;

--Script 11: For each quarter, list the minimum, maximum and average salaries offered.
 SELECT 'Script 11' FROM dual;
 SELECT q.qtrcode, TO_CHAR(MIN(i.salaryoffered), '99.99') AS "MIN", 
	TO_CHAR(MAX(i.salaryoffered), '99.99') AS "MAX",
	TO_CHAR(AVG(i.salaryoffered), '99.99') AS "AVG"
 FROM interview i INNER JOIN quarter q ON i.qtrcode = q.qtrcode 
 GROUP BY q.qtrcode;
 
 --Script 12: For each state in which an employer is located, list the minimum, maximum
 --and average salaries offered.
SELECT 'Script 12' FROM dual;
SELECT e.statecode,
	TO_CHAR(MIN(i.salaryoffered), '99.99') AS "MIN", 
	TO_CHAR(MAX(i.salaryoffered), '99.99') AS "MAX",
	TO_CHAR(AVG(i.salaryoffered), '99.99') AS "AVG"
FROM interview i INNER JOIN jobsdev.employer e ON e.companyname=i.companyname
GROUP BY e.statecode;

--Script 13: For each quarter, display the quarter, the salary desired for that quarter, and the
--average salary offered during all the interviews for that quarter.
SELECT 'Script 13' FROM dual;
SELECT q.qtrcode AS "QTR", minsal AS "Desired", averageSal AS "AVG OFFER" 
FROM  quarter q,
	(SELECT avg(salaryoffered) as averageSal, qtrcode 
	FROM interview 
	GROUP BY qtrcode) i
WHERE q.qtrcode = i.qtrcode;

--Script 14: For each quarter, display the quarter, the number of interviews, the total
--number of days between the first interview and the last, the date of the first interview, and
--the date of the last interview
SELECT quarter.qtrcode AS "QTR", 
	count(interviewid) AS "INTERVIEWS",  
	trunc(((86400*(max(interviewdate)-min(interviewdate))/60)/60)/24) AS "TOTAL DAYS",
	TO_CHAR(min(interviewdate),'FMMONTH DD,YYYY') AS "FROM",
	TO_CHAR(max(interviewdate), 'FMMONTH DD,YYYY') AS "TO"
FROM quarter INNER JOIN interview ON quarter.qtrcode = interview.qtrcode 
GROUP BY quarter.qtrcode;


--Script 15
COLUMN 'Interview Data' CENTER
SELECT ('For: ' || quarter.qtrcode 
	|| ': ' ||  count(interviewid) ||' interviews over ' 
	|| trunc(((86400*(max(interviewdate)-min(interviewdate))/60)/60)/24) 
	|| ' days, from ' 
	|| TO_CHAR(min(interviewdate),'FMMONTH DD,YYYY') || ' to '
	|| TO_CHAR(max(interviewdate), 'FMMONTH DD,YYYY')) AS "Interview Data" 
FROM quarter INNER JOIN interview ON quarter.qtrcode = interview.qtrcode 
GROUP BY quarter.qtrcode;