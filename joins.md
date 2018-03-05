Connect tables by their keys using JOINS

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