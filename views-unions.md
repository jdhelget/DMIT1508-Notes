#SQL Views

A view is a query that is stored in the database. It behaves very much like a virtual table that was created by selecting rows and columns from other tables. In most situations it can be used just like an actual table. There is no real overhead with creating a view, as there is no actual data stored in the view. It is created by select statement(s) and the data remains in the original tables.

Some common uses for SQL views are:
    - simplifying data retrieval from complex queries
    - hiding the underlying table structure
    - controlling access to data for different users

-- View Exercise
-- If an operation fails write a brief explanation why. Do not just quote the error message genereated by the server!

USE [A01-School]
GO

--1.  Create a view of staff full names called StaffList.
IF OBJECT_ID('StaffList', 'V') IS NOT NULL
    DROP VIEW StaffList
GO
CREATE VIEW StaffList
AS
    SELECT  FirstName + ' ' + LastName AS 'StaffFullName'
    FROM    Staff
GO
-- Now we can use the StaffList view as if it were a table
SELECT	StaffFullName
FROM	StaffList

-- SP_HELPTEXT StaffList    -- Gets the text of the View
-- SP_HELP StaffList        -- Gets schema info on the View

--2.  Create a view of staff ID's, full names, positionID's and datehired called StaffConfidential.
IF OBJECT_ID('StaffConfidential', 'V') IS NOT NULL
    DROP VIEW StaffConfidential
GO

CREATE VIEW	StaffConfidential
AS
	SELECT	StaffID, FirstName + ' ' + LastName AS 'StaffFullName', PositionID, DateHired
	FROM	Staff
GO
-- I can use it accordingly:
SELECT	StaffFullName, DateHired
FROM	StaffConfidential

-- 2a. Alter the StaffConfidential view so that it includes the position name.
ALTER VIEW	StaffConfidential
AS
	SELECT	StaffID,
			FirstName + ' ' + LastName AS 'StaffFullName',
			P.PositionId,
			PositionDescription AS 'Position',
			DateHired
	FROM	Staff S
		INNER JOIN Position P ON S.PositionID = P.PositionID
GO

SELECT	StaffFullName, Position, PositionID
FROM	StaffConfidential

--3.  Create a view of student ID's, full names, courseId's, course names, and grades called StudentGrades.
IF OBJECT_ID('StudentGrades', 'V') IS NOT NULL
    DROP VIEW StudentGrades
GO

CREATE VIEW	StudentGrades
AS
	SELECT	S.StudentId, 
			FirstName + ' ' + LastName AS 'FullName',
			C.CourseId,
			C.CourseName,
			R.Mark
	FROM	Student S
		INNER JOIN	Registration R ON S.StudentID = R.StudentID
		INNER JOIN	Course C ON R.CourseId = C.CourseId
GO

--4.  Use the student grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
SELECT	StudentId, FullName, CourseName, Mark
FROM	StudentGrades
WHERE	StudentId = 199899200

--5.  Select the same information using the student grades view for studentID 199912010.
SELECT	StudentId, FullName, CourseName, Mark
FROM	StudentGrades
WHERE	StudentId = 199912010

--6.  Using the student grades view  update the mark for studentID 199899200 in course dmit152 to be 90  and change the coursename to be 'basket weaving 101'.
UPDATE		StudentGrades
	SET		Mark = 90
	WHERE	CourseId = 'dmit152' AND StudentID = 199899200
UPDATE		StudentGrades
	SET		CourseName = 'Basket Weaving 101'
	WHERE	CourseId = 'dmit152'

--7.  Using the student grades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
UPDATE		StudentGrades
	SET		Mark = 90
	WHERE	CourseId = 'dmit152' AND StudentID = 199899200

--8.  Using the student grades view, delete the same record from question 7.

--9.  Retrieve the code for the student grades view from the database.


--Union Exercise (using the IQSchool database)
USE [A01-School]
GO

--1.	Write a script that will produce the 'It Happened in October' display.
--The output of the display is shown below
/*
    It Happened in October
 
    ID          Event:Name
    ----------- -----------------------------------
    200645320   Student Born:Thomas Brown
    200322620   Student Born:Flying Nun
    7           Staff Hired:Hugh Guy
    6           Staff Hired:Sia Latter
*/
--Additional Info:

---	if the event is an staff  being hired:
---	the id column contains the employee id
---	the name is in the format 'FirstName LastName'
---	if the event is a Student birthdate:
---	the id column contains the Student id
---	the name is in the format 'FirstName LastName'
---	the data is sorted in descending order of id (Student or staff)
---	the display is limited to the hiring of staff or the birthdates of students in the month of October

SELECT  StudentID AS 'ID',
        'Student Born:' + FirstName + ' ' +  LastName AS 'Event:Name'
--        , MONTH(Birthdate)
FROM    Student
WHERE   MONTH(Birthdate) = 10

UNION

SELECT  StaffID AS 'ID',
        'Staff Hired:' + FirstName + ' ' + LastName AS 'Event:Name'
FROM    Staff
WHERE   MONTH(DateHired) = 10

ORDER BY 'ID' DESC

-- Create a View called RollCall that has the full name of each staff and student as wellas identifying their role in the school.
IF OBJECT_ID('RollCall', 'V') IS NOT NULL
    DROP VIEW RollCall
GO

CREATE VIEW	RollCall
AS
-- Get all the students
SELECT	FirstName + ' ' + LastName AS 'FullName',
		'Student' AS 'Role' -- 'Student' is just a hard-coded value
FROM	Student

UNION

-- Get all the staff
SELECT	FirstName + ' ' + LastName AS 'FullName',
		PositionDescription AS 'Role'
FROM	Staff S
	INNER JOIN Position P ON S.PositionID = P.PositionID
