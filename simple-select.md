- SQL clauses of the Select statement:
	- SELECT: A comma-seperated list of columns and/or expressions
	- FROM: A set of one or more (joined) tables
	- WHERE: Filter the results based on column values


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