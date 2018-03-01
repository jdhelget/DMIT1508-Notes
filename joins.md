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


--2.	Select the Staff full names and the Course ID’s they teach


--3.	Select all the Club ID's and the Student full names that are in them
-- TODO: Student Answer Here...


--4.	Select the Student full name, courseID's and marks for studentID 199899200.


--5.	Select the Student full name, course names and marks for studentID 199899200.
-- TODO: Student Answer Here...


--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
-- TODO: Student Answer Here...


--7.	What Staff Full Names have taught Networking 1?
-- TODO: Student Answer Here...


--8.	What is the course list for student ID 199912010 in semester 2001S. Select the Students Full Name and the CourseNames
-- TODO: Student Answer Here...


--9. What are the Student Names, courseID's that have Marks >80?
-- TODO: Student Answer Here...
