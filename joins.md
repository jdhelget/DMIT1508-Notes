Connect tables by their keys using JOINS

Think of "Joining tables" as creating a bigger/mega/huge table of data.
Joining tables (almost) always has a multiplying effect on the overall number of rows in the resulting data set.

-- Inner Join: Data must exist in both of the joined tables.
-- Outer Join: Data only has to exist in one of the joined tables
--		

--Joins Exercise 1
USE [A01-School]
GO

--1.	Select Student full names and the course ID's they are registered in.
SELECT		FirstName + ' ' + LastName AS 'Full Name',
			CourseId
FROM		Student
				INNER JOIN Registration
					ON Student.StudentID =
						Registration.StudentID

--1.a. Select Student full names, the course ID and the course name that the students are registered in.
SELECT		FirstName + ' ' + LastName AS 'Full Name',
			C.CourseId, CourseName
FROM		Student S
				INNER JOIN Registration R
					ON S.StudentID =
						R.StudentID
				INNER JOIN Course C
					ON R.CourseId = 
						C.CourseId

--2.	Select the Staff full names and the Course ID’s they teach
SELECT DISTINCT	-- The DISTINCT keyword will remove duplicate rows from the results
			FirstName + ' ' + LastName AS 'Full Name',
			CourseID
FROM		Staff S
				INNER JOIN Registration R
					ON S.StaffID = R.StaffID
ORDER BY	'Full Name', CourseId

--3.	Select all the Club ID's and the Student full names that are in them
SELECT		S.FirstName + ' ' + S.LastName AS 'Student Full Name',
			C.ClubId
FROM		Activity C
	INNER JOIN Student S
		ON S.StudentID = C.StudentId


--4.	Select the Student full name, courseID's and marks for studentID 199899200.
SELECT	S.FirstName + ' ' + S.LastName AS 'Student Name',
		R.CourseID,
		R.Mark
FROM	Registration R
	INNER JOIN Student S
			ON S.StudentID = R.StudentID
WHERE	S.StudentId = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
SELECT	S.FirstName + ' ' + S.LastName AS 'Student Full Name',
		C.CourseName,
		R.Mark
FROM	Registration R
	INNER JOIN Student S
		ON S.StudentID = R.StudentID
	INNER JOIN Course C
		ON C.CourseId = R.CourseId
WHERE S.StudentID = 199899200


--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
SELECT DISTINCT
		R.CourseId,
		C.CourseName,
		R.Semester
FROM	Registration R
	INNER JOIN Course C
		ON C.CourseID = R.CourseID

--7.	What Staff Full Names have taught Networking 1?
SELECT DISTINCT
		S.FirstName + ' ' + S.LastName AS 'Staff Full Name',
		C.CourseName
FROM	Staff S
	INNER JOIN Registration R
		ON R.StaffId = S.StaffID
	INNER JOIN Course C
		ON C.CourseId = R.CourseId
WHERE CourseName = 'Networking 1'

--8.	What is the course list for student ID 199912010 in semester 2001S. Select the Students Full Name and the CourseNames
SELECT	S.FirstName + ' ' + S.LastName AS 'Student Full Name',
		C.CourseName
FROM	Registration R
	INNER JOIN Student S
		ON S.StudentID = R.StudentID
	INNER JOIN Course C
		ON C.CourseID = R.CourseID
WHERE	S.StudentID = 199912010
	AND R.Semester = '2001S'

--9. What are the Student Names, courseID's that have Marks >80?
SELECT DISTINCT
		S.FirstName + ' ' + S.LastName AS 'Student Full Name',
		C.CourseID,
		R.Mark
FROM	Registration R
	INNER JOIN Student S
		ON S.StudentId = R.StudentId
	INNER JOIN Course C
		ON C.CourseID = R.CourseID
WHERE R.Mark > 80

--Inner Joins With Aggregates Exercises
USE [A01-School]
GO

--1. How many staff are there in each position? Select the number and Position Description
SELECT  PositionDescription,                    --  <-- non-aggregate
        COUNT(S.StaffID) AS 'Number of Staff'   --  <-- aggregate
FROM    Staff S
    INNER JOIN Position P ON P.PositionID = S.PositionID
GROUP BY PositionDescription 
 
--2. Select the average mark for each course. Display the CourseName and the average mark. Sort the results by average in descending order.
SELECT  CourseName, AVG(Mark) AS 'Average Mark'
FROM    Registration R
    INNER JOIN Course C ON R.CourseId = C.CourseId
GROUP BY CourseName
ORDER BY 'Average Mark' DESC

--3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count
 -- TODO: Student Answer Here... 

 
--4. Select the average Mark for each student. Display the Student Name and their average mark. Use table aliases in your FROM & JOIN clause.
SELECT  S.FirstName  + ' ' + S.LastName AS 'Student Name',
        AVG(R.Mark)                     AS 'Average'
FROM    Registration R
        INNER JOIN Student S
            ON S.StudentID = R.StudentID
GROUP BY    S.FirstName  + ' ' + S.LastName  -- Since my non-aggregate is an expression,
                                             -- I am using the same expression in my GROUP BY

--5. Select the same data as question 4 but only show the student names and averages that are > 80. (HINT: Remember the HAVING clause?)
 -- TODO: Student Answer Here... 

 
--6.what is the highest, lowest and average payment amount for each payment type Description? 
 -- TODO: Student Answer Here... 

 
--7. Which clubs have 3 or more students in them? Display the Club Names.
 -- TODO: Student Answer Here... 


--Outer Joins Exercise
USE [A01-School]
GO

--1. Select All position descriptions and the staff ID's that are in those positions
SELECT  PositionDescription, StaffID
FROM    Position P -- Start with the Position table, because I want ALL position descriptions...
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
SELECT  PositionDescription,
        COUNT(StaffID) AS 'Number of Staff'
FROM    Position P
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription
-- but -- The following version gives the WRONG results, so just DON'T USE *  !
SELECT PositionDescription, 
       Count(*) -- this is counting the WHOLE row (not just the Staff info)
FROM   Position P
    LEFT OUTER JOIN Staff S
        ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        AVG(Mark) AS 'Average'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--4. Select the highest and lowest mark for each student. 
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        MAX(Mark) AS 'Highest',
		MIN(Mark) 'Lowest'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--5. How many students are in each club? Display club name and count.
 SELECT	ClubName,
		COUNT(StudentId) AS 'Student Count'
 FROM	Club C
	LEFT OUTER JOIN Activity A
		ON C.ClubId = A.ClubId
GROUP BY ClubName