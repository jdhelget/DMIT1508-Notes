-- String and Date Functions Exercise
USE [A01-School]
GO

-- 1. Select the staff names and the name of the month they were hired
SELECT  FirstName, LastName, DATENAME(mm, DateHired) AS 'Month Hired'
FROM    Staff

-- 2. How many days did Tess Agonor work for the school?
SELECT  DATEDIFF(dd, DateHired, DateReleased)
FROM    Staff
WHERE   FirstName = 'Tess'
  AND   Lastname = 'Agonor'

-- 2a. How long have I worked for this school??
SELECT  DATEDIFF(dd, 'Jan 1, 2000', GETDATE())

-- 3. How Many Students where born in each month? Display the Month Name and the Number of Students.
SELECT  DATENAME(mm, Birthdate) AS 'Month Name',
        COUNT(1) AS 'Number of Students'
FROM    Student
GROUP BY DATENAME(mm, Birthdate)

-- 4. Select the Names of all the students born in December.
SELECT  FirstName, LastName
FROM    Student
WHERE   DATENAME(mm, Birthdate) = 'December'

-- 5. Select all the course names that have grades from 2004. NOTE: the first 4 characters of the semester indicate the year.
SELECT  DISTINCT
        CourseName
FROM    Registration R
    INNER JOIN Course C ON C.CourseId = R.CourseId
WHERE   Mark IS NOT NULL
  AND   LEFT(Semester, 4) = 2004

-- 6. select last three characters of all the courses


-- 7. Select the characters in the position description from characters 8 to 13 for PositionID 5


-- 8. Select all the Student First Names as upper case.


-- 9. Select the First Names of students whose first names are 3 characters long.


/*
    String Functions
    ================
    (See https://technet.microsoft.com/en-us/library/ms181984(v=sql.105).aspx)

    LEN ( string_expression )                                               SELECT LEN('Daniel Gilleland')
    LEFT ( character_expression , integer_expression )                      SELECT LEFT('Daniel Gilleland', 3)
    RIGHT ( character_expression , integer_expression )                     SELECT RIGHT('Daniel Gilleland', 4)
    SUBSTRING ( value_expression , start_expression , length_expression )   SELECT SUBSTRING('Daniel', 2, 2)
    LTRIM ( character_expression )                                          SELECT LTRIM('   Danny    ')
                                                                            SELECT RIGHT(LTRIM('   Danny    '), 5)
    RTRIM ( character_expression )                                          SELECT RTRIM('   Danny    ')
                                                                            SELECT LEFT(RTRIM('   Danny    '), 5)
    LOWER ( character_expression )                                          SELECT LOWER('AWESOME!')
    UPPER ( character_expression )                                          SELECT UPPER('boring')
    REPLACE ( string_expression , string_pattern , string_replacement )     SELECT REPLACE('Daniel', 'iel', 'YELL')



    DATE Functions
    ==============
    
    GETDATE ()                  returns the system date
    
    DATEADD (xx, n, date1)      returns a new date adding the number of xx to date1; n may be negative
    
    DATEDIFF (xx, date1, date2) returns the number of xx from date1 (older) to date2 (newer) � can return negative numbers
    
    DATENAME (xx, date1)        returns a string representation of the xx of date1
    
    DATEPART (xx, date1)        returns an integer representation of the xx of date1
    
    YEAR (date1)                returns the year portion of date1, same functionality as DATEPART (yy, date1)
    
    MONTH  (date1)              returns the month portion of date1, same functionality as DATEPART (mm, date1)
    
    DAY (date1)                 returns the day portion of date1, same functionality as DATEPART (dd, date1)
    
    
    NOTE: xx represents the datepart from the table below.

Datepart        Abbreviation  Minimum        Maximum
Year            yy            1753            9999
Quarter         qq               1               4
Month           mm               1              12
Week            wk               1              53
Day of year     dy               1             366
WeekDay         dw               1 (Sun.)        7 (Sat.)
Day             dd               1              31
Hour            hh               0              23
Minute          mi               0              59
Second          ss               0              59
Millisecond     ms               0             999


*/