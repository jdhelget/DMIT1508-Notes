- SQL clauses of the Select statement:
	- SELECT: A comma-seperated list of columns and/or expressions.
	- FROM: A set of one or more (joined) tables.
	- WHERE: Filter the results based on column values.
	- GROUP BY: Takes the results of SELECT & FROM and produces another set of results where similar values exist for the GROUP BY columns.
	- HAVING: Used to filter the results based on aggregate values.
	- ORDER BY:


-- SIMPLE SELECT EXERCISE 1

USE [A01-School]
GO

-- Simple Select, without any other clauses
SELECT 'Dan', 'Gilleland'

-- Simple Select with expressions
SELECT 'Dan' + ' ' + 'Gilleland', 18 * 52

-- Specify a column name with some hard-code/calculated values
SELECT 'Dan' + ' ' + 'Gilleland' AS 'Instructor',
	   18 * 52 AS 'Weeks at the job'

-- Let's use the Select statement with database tables

-- 1. Select all the information from the Club table
SELECT	ClubId, ClubName
FROM	Club 
-- Pro tip: If you write the FROM clause before specifying the columns,
--			you will get intellisense help on the column names
-- Pro tip: Press [ctrl] + [shift] + [R] to "refresh" intellisense

-- 2. Select the FirstNames and LastNames of all the students
SELECT	FirstName, LastName
FROM	Student
-- 2.a Repeat the above query, but using column aliases
SELECT	FirstName AS 'First Name', LastName AS 'Last Name'
FROM	Student
-- 2.b Select the student id and full name of all the students
SELECT	StudentId, FirstName + ' ' + LastName AS 'Full Name'
FROM	Student

-- 3. Select all the CourseId and CourseName of all the courses. Use the column aliases of Course Id and Course Name
Select	CourseId AS 'Course ID', CourseName AS 'Course Name'
FROM	Course

-- 4. Select all the course information for CourseID 'DMIT101'
SELECT	CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM	Course
WHERE	CourseID = 'DMIT101'

-- 5. Select the Staff names who have positionID of 3
SELECT	FirstName, LastName
		--,PositionID -- Press [ctrl] + K, then [ctrl] + U to un-comment
FROM	Staff
WHERE	PositionID = 3

--BTW, what is positionID of 3 referring to?
SELECT	PositionID, PositionDescription
FROM	Position

-- 6. Select the course names whose course hours are less than 96
SELECT	C.CourseName
FROM	Course C -- I can have an alias to the table name
WHERE	C.CourseHours < 96

--7. Select the StudentID's, CourseID and mark where the Mark is between 70 and 80
SELECT StudentID, CourseID, Mark
FROM Registration
WHERE Mark >= 70 AND Mark <= 80
--	  Mark BETWEEN 70 AND 80

--7.a Select the StudentID's where the withdrawal status is null
SELECT	StudentID 
FROM	Registration
WHERE	WithdrawYN IS NULL

--7.b Select the StudentID's of students who have withdrawn from a course
SELECT	StudentID
FROM	Registration
WHERE	WithdrawYN = 'Y'

--8. Select the StudentID's, CourseID and mark where the mark is between 70 and 80
--	 and the CourseID is DMIT 1223 or DMIT168
SELECT	StudentID, CourseID, Mark
FROM	Registration 
WHERE	Mark >= 70 AND Mark <= 80 AND CourseID = 'DMIT1223' AND CourseID = 'DMIT168'
-- Alternate answer
SELECT	R.StudentID, R.CourseId, R.Mark
FROM	Registration R
WHERE	R.Mark BETWEEN 70 and 80
  AND	R.CourseId IN ('DMIT1223', 'DMIT168')

--8.a Select the StudentID's, CourseID and mark where the mark is 80 and 85
SELECT	StudentID, CourseID, Mark
FROM	Registration
WHERE	Mark = '80' OR Mark = '85'

-- The next two questions introduce the idea of "wildcards" and pattern matching in the WHERE clause
-- _ is a wildcard for a single character
-- % is a wildcard for zero or more characters
-- [] is a pattern for a single character matching the pattern in the square brackets

-- 9. Select the students first name and last names who have last names starting with S
SELECT	FirstName, LastName
FROM Student
WHERE LastName LIKE 'S%'

-- 10. Select courseNames whose CourseId have a 1 as the fifth character
SELECT	CourseName
FROM	Course
WHERE	CourseID LIKE '____1%'

-- 11. Select the CourseID's and course names where the course name contains the word 'programming'
SELECT	CourseId, CourseName
FROM	Course
WHERE	CourseName LIKE '%programming%'

-- 12. Select all the club names who start with N or C
SELECT	ClubName
FROM	Club
WHERE	ClubName LIKE 'N%' OR ClubName LIKE 'C%'

-- 13. Select the student names, street address and city where the lastname only contains 3 letters
SELECT	FirstName + ' ' + LastName, StreetAddress, City
FROM	Student
WHERE	LastName LIKE '___'

-- 14. Select all the studentID's where the payement amount < 500 OR the PaymenttypeID is 5
SELECT	StudentId
FROM	Payment
WHERE	Amount < 500 OR PaymentId LIKE '5'

--Simple Select Exercise 2
-- This set of exercises demonstrates performing simple Aggregate functions
-- to get results such as SUM(), AVG(), COUNT() 
-- All aggregates are done using built-in functions in the database


--1.	Select the average Mark from all the Marks in the registration table
SELECT	AVG(Mark) AS 'Average Mark'
FROM	Registration

--1.a.  Show the average mark, the total of all marks, and a count of all marks.
SELECT	AVG(Mark) AS 'Average Mark', 
		SUM(Mark) AS 'Total of all Marks', 
		COUNT(Mark) AS 'How many Marks'
FROM Registration

--2.	Select the average Mark of all the students who are taking DMIT104
SELECT	AVG(Mark) AS 'Average Mark'
FROM	Registration
WHERE	CourseID LIKE 'DMIT104'

--3.	Select how many students are there in the Student Table
SELECT	COUNT(StudentId) AS 'Student Count'
FROM	Student

--4.	Select how many students are taking (have a grade for) DMIT152
SELECT	COUNT(Mark) AS 'Student Count for DMIT 152'
FROM	Registration
WHERE	CourseId = 'DMIT152'

--5.	Select the average payment amount for payment type 5
SELECT	AVG(Amount)
FROM	Payment
WHERE	PaymentTypeID LIKE '5'

-- Given that there are some other aggregate methods like MAX(columnName) and MIN(columnName), complete the following two questions:
--6. Select the highest payment amount
SELECT	MAX(Amount) AS 'Highest Payment'
FROM	Payment

--7.	 Select the lowest payment amount
SELECT	MIN(Amount) AS 'Lowest Payment'
FROM	Payment

--8. Select the total of all the payments that have been made
SELECT	SUM(Amount) AS 'Total of Payments'
FROM	Payment

--9. How many different payment types does the school accept?
SELECT	COUNT(PaymentTypeID) AS 'Number of Payment Types'
FROM	Payment

--10. How many students are in club 'CSS'?
SELECT	COUNT(StudentID) AS 'Student Count for Club CSS'
FROM	Activity
WHERE	ClubId = 'CSS'

--Simple Select Exercise 3
-- This sample set illustrates the GROUP BY syntax and the use of Aggregate functions
-- with GROUP BY.
-- It also demonstrates the HAVING clause to filter on aggregate values.
USE [A01-School]
GO


--1. Select the average mark for each course. Display the CourseID and the average mark
-- Let's begin by exploring the Registration table to see the data we are working with.
SELECT		CourseId, Mark
FROM		Registration
ORDER BY	CourseId

-- Answer to #1
SELECT		CourseId,					-- This column is a non-aggregate
			AVG(Mark) AS 'Average Mark' -- This column performs Aggregate(Produce 1 value)
FROM		Registration
GROUP BY	CourseId					-- Group by the non-aggregate Columns
-- When performing an aggregate function in the SELECT clause, if you have any other non-aggregate
-- columns in the SELECT clause, then these must be listed in the GROUP BY clause.

--2. How many payments were made for each payment type. Display the Payment Type ID and the count
SELECT		PaymentTypeID, 
			COUNT(PaymentId) AS 'Count of Pay Type'
FROM		Payment
GROUP BY	PaymentTypeID
-- 2a. Do the same as above, but sort it from the most frequent payment type to the least frequent
SELECT		PaymentTypeID, 
			COUNT(PaymentId) AS 'Count of Pay Type'
FROM		Payment
GROUP BY	PaymentTypeID
ORDER BY	COUNT(PaymentTypeID)

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT		StudentId,
			AVG(Mark) AS 'Average Mark'
FROM		Registration
GROUP BY	StudentID

--4. Select the same data as question 3 but only show the studentID's and averages that are > 80
SELECT		StudentId,
			AVG(Mark) AS 'Average Mark'
FROM		Registration
GROUP BY	StudentID
-- The HAVING clause is where we do filtering of Aggregate information
HAVING		AVG(Mark) > 80

--5. How many students are from each city? Display the City and the count.
SELECT		City,
			COUNT(StudentId) AS ' Student Count'
FROM		Student
GROUP BY	City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT		City
			--, COUNT(StudentID) AS 'Student Count'
FROM		Student
GROUP BY	City
HAVING		COUNT(StudentId) >= 2

--7. What is the highest, lowest and average payment amount for each payment type? 
SELECT		MAX(Amount) AS 'Highest',
			MIN(Amount) AS 'Lowest',
			AVG(Amount) AS 'Average'
			, PaymentTypeID
FROM		Payment
GROUP BY	PaymentTypeID

--8. How many students are there in each club? Show the clubID and the count
SELECT		ClubId,
			COUNT(StudentId)
FROM		Activity
GROUP BY	ClubId

--9. Which clubs have 3 or more students in them?
SELECT		ClubId,
			COUNT(StudentId)
FROM		Activity
GROUP BY	ClubId
HAVING		COUNT(StudentId) >= 3