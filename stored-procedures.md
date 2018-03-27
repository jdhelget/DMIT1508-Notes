--Stored Procedures (Sprocs)

USE [A01-School]
GO

/* *******************************************
  Each Stored Procedure has to be the first statement in a batch,
    so place a GO statement in-between each question to execute 
    the previous batch (question) and start another.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
    DROP PROCEDURE SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'GetName')
    DROP PROCEDURE GetName
GO
CREATE PROCEDURE GetName
    -- Parameters here
AS
    -- Body of procedure here
    SELECT  'Dan', 'Gilleland'
RETURN
GO

-- Execute (run/call) the stored procedure as follows:
EXEC GetName



--1.	Create a stored procedure called "HonorCourses" to select all the course names that have averages >80%.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'HonorCourses')
    DROP PROCEDURE HonorCourses
GO
CREATE PROCEDURE HonorCourses
    -- Parameters here
AS
    -- Body of procedure here
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO
-- To actually execute (run) the stored procedure, you call EXEC
EXEC HonorCourses


--2.	Create a stored procedure called "HonorCoursesOneTerm" to select all the course names that have average > 80% in semester 2004J.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'HonorCoursesOneTerm')
    DROP PROCEDURE HonorCoursesOneTerm
GO
CREATE PROCEDURE HonorCoursesOneTerm
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = '2004J'
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO

--3.	Oops, made a mistake! For question 2, it should have been for semester 2004S. Write the code to change the procedure accordingly. 
ALTER PROCEDURE HonorCoursesOneTerm
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = '2004S'
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO

--3.B. Your instructor is back, and recommends that the previous stored procedure use a parameter for the semester, making it more "re-usable"
ALTER PROCEDURE HonorCoursesOneTerm
    @Semester   char(5)
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = @Semester
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO
-- Now the stored procedure can be called with any semester I want
EXEC HonorCoursesOneTerm '2004S'
EXEC HonorCoursesOneTerm '2004J'

--4. Create a stored procedure called CourseCalendar that lists the course ID, name, and cost of all available courses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CourseCalendar')
    DROP PROCEDURE CourseCalendar
GO
CREATE PROCEDURE CourseCalendar
    -- Parameters here
AS
    -- Body of procedure here
	SELECT	CourseId, CourseName, CourseCost
	FROM	Course
RETURN
GO

EXEC CourseCalendar

--4.B.	Create a stored procedure called "NotInCourse" that lists the full names of the students that are not in a particular course. The stored procedure should expect the course number as a parameter. e.g.: DMIT221.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'NotInCourse')
    DROP PROCEDURE NotInCourse
GO
CREATE PROCEDURE NotInCourse
    -- Parameters here
    @CourseNumber   char(7)
AS
    -- Body of procedure here
    SELECT  DISTINCT FirstName + ' ' + LastName AS 'Student Name'        
    FROM    Student S
        INNER JOIN Registration R ON S.StudentID = R.StudentID
    WHERE   R.CourseId <> @CourseNumber -- <> is the "not equal to" operator
RETURN
GO
-- Try it out.....
EXEC NotInCourse 'DMIT221'


--5.	Create a stored procedure called "LowNumbers" to select the course name of the course(s) that have had the lowest number of students in it.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'LowNumbers')
    DROP PROCEDURE LowNumbers
GO
CREATE PROCEDURE LowNumbers
    -- Parameters here
AS
    -- Body of procedure here
    SELECT  C.CourseName
--           ,COUNT(R.StudentID) AS 'Enrollement Count'
    FROM    Course C
        LEFT OUTER JOIN Registration R ON C.CourseId = R.CourseId
    GROUP BY C.CourseName
    HAVING COUNT(R.StudentID) <= ALL (SELECT COUNT(StudentID)
                                      FROM   Course C
                                          LEFT OUTER JOIN Registration R
                                              ON C.CourseId = R.CourseId
                                      GROUP BY C.CourseId)
    -- Notice that the subquery uses a left outer join. This is so that it includes courses
    -- that do not yet have registrations (in which case, it will be a zero enrollment).
    -- An acceptable alternate would be this....
    --HAVING COUNT(R.StudentID) <= ALL (SELECT COUNT(StudentID)
    --                                  FROM   Registration
    --                                  GROUP BY CourseId)
RETURN
GO
-- Run the above with the database as-is, and you will see three courses coming back.
EXEC LowNumbers
INSERT INTO Course(CourseId, CourseName, CourseHours, CourseCost, MaxStudents)
VALUES ('DMIT987', 'Advanced Logic', 90, 420.00, 12)
-- Now, run the stored procedure and you will see only this new course
EXEC LowNumbers

--6.	Create a stored procedure called "Provinces" to list all the students provinces.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'Provinces')
    DROP PROCEDURE Provinces
GO
CREATE PROCEDURE Provinces
AS
SELECT	FirstName + ' ' + LastName AS 'FullName', Province
FROM	Student
RETURN
GO

EXEC Provinces

--7.	OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.

DROP PROCEDURE Provinces
GO

--8.	Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment types. Ensure all the student names are listed.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StudentPaymentTypes')
    DROP PROCEDURE StudentPaymentTypes
GO
CREATE PROCEDURE StudentPaymentTypes
    -- Parameters here
AS
    -- Body of procedure here
	SELECT	FirstName + ' ' + LastName AS 'FullName', PT.PaymentTypeDescription
	FROM	Student S
		INNER JOIN Payment P
			ON P.StudentID = S.StudentID
		INNER JOIN PaymentType PT
			ON PT.PaymentTypeID = P.PaymentTypeID
RETURN
GO

EXEC StudentPaymentTypes

--9.	Modify the procedure from question 8 to return only the student names that have made payments.
ALTER PROCEDURE StudentPaymentTypes
    -- Parameters here
AS
    -- Body of procedure here
	SELECT	FirstName + ' ' + LastName AS 'FullName', PT.PaymentTypeDescription
	FROM	Student S
		INNER JOIN Payment P
			ON P.StudentID = S.StudentID
		INNER JOIN PaymentType PT
			ON PT.PaymentTypeID = P.PaymentTypeID
	WHERE	PaymentID IS NOT NULL
RETURN
GO

EXEC StudentPaymentTypes

-- Add a Club

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'AddClub')
    DROP PROCEDURE AddClub
GO
CREATE PROCEDURE AddClub
	-- Columns must start with a @
    @ClubId		varchar(10),
	@ClubName	varchar(50)
AS
    -- Body of procedure here
	INSERT INTO	Club(ClubID, ClubName)
	VALUES	(@ClubID, @ClubName)
RETURN

-- Execute Procedure
EXEC	AddClub 'SQL1', 'SQL Dance Club'
GO

-- Get the SP source code from the db
sp_helptext AddClub
GO

-- Check for parameter values not being passed
ALTER PROCEDURE AddClub
--	Default ther parameters to NULL so they always have a value, even if not passed one
    @ClubId		varchar(10)=NULL,
	@ClubName	varchar(50)=NULL
AS
	IF @ClubId IS NULL OR @ClubName IS NULL
		BEGIN
		RAISERROR('ClubID and ClubName are required',16,1)
		END
	ELSE
		BEGIN
		INSERT INTO	Club(ClubID, ClubName)
		VALUES	(@ClubID, @ClubName)
	END
RETURN

-- Return the ERROR message
EXEC	AddClub

-- Create a Proc that will change the mailing address for a student. Call it ChangeMailingAddress.
-- Make sure all the parameter values are supplied before running the update (not null)

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ChangeMailingAddress')
    DROP PROCEDURE ChangeMailingAddress
GO
CREATE PROCEDURE ChangeMailingAddress
	@StudentID		int=NULL,
	@StreetAddress	varchar(35)=NULL,
	@City			varchar(30)=NULL,
	@Province		char(2)=NULL,
	@PostalCode		char(6)=NULL
AS
    IF @StudentID IS NULL OR @StreetAddress IS NULL OR @City IS NULL OR @Province IS NULL OR @PostalCode IS NULL
		BEGIN
		RAISERROR ('StreetAddress, City, Province, and PostalCode are all required', 16, 1)
		END
	ELSE
		BEGIN
		UPDATE	Student
		SET		StreetAddress = @StreetAddress,
				City = @City,
				Province = @Province, 
				PostalCode = @PostalCode
		WHERE	StudentID = @StudentId
	END
RETURN


-- 3. Create a stored procedure that will remove a student from a club. Call it RemoveFromClub.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'RemoveFromClub')
    DROP PROCEDURE RemoveFromClub
GO
CREATE PROCEDURE RemoveFromClub
	@StudentID	int=NULL,
    @ClubId		varchar(10)=NULL
AS
	IF @StudentId IS NULL OR @ClubID IS NULL
		BEGIN
		RAISERROR('StudentID and ClubID are required',16,1)
		END
	ELSE
		DELETE FROM Activity
		WHERE	StudentID = @StudentID AND ClubID = @ClubID
RETURN

EXECUTE	RemoveFromClub 199899200, 'CSS'

SELECT	StudentID
FROM	Activity
WHERE	ClubId = 'CSS'

-- Query-based Stored Procedures
-- 4. Create a stored procedure that will display all the staff and their position in the school.
--    Show the full name of the staff member and the description of their position.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisplayStaff')
    DROP PROCEDURE DisplayStaff
GO
CREATE PROCEDURE DisplayStaff
AS
	SELECT	FirstName + ' ' + LastName AS 'FullName',
			P.PositionDescription
	FROM	Staff S
		INNER JOIN Position P
			ON P.PositionId = S.PositionID
RETURN

EXECUTE	DisplayStaff

-- 5. Display all the final course marks for a given student. Include the name and number of the course
--    along with the student's mark.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisplayStudentFinalMark')
    DROP PROCEDURE DisplayStudentFinalMark
GO
CREATE PROCEDURE DisplayStudentFinalMark
	@StudentId	int=Null
AS
	IF @StudentId is NULL
		BEGIN
		RAISERROR ('StudentId is Required',16,1)
		END
	ELSE
	SELECT	FirstName + ' ' + LastName AS 'FullName',
			C.CourseName,
			R.Mark
	FROM	Student S
		INNER JOIN Registration R
			ON R.StudentID = S.StudentID
		INNER JOIN Course C
			ON C.CourseId = R.CourseID
	WHERE S.StudentID = @StudentId
RETURN

EXECUTE DisplayStudentFinalMark 199899200

-- 6. Display the students that are enrolled in a given course on a given semester.
--    Display the course name and the student's full name and mark.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'Attendance')
    DROP PROCEDURE Attendance
GO
CREATE PROCEDURE Attendance
	@CourseId	char(7)=NULL,
	@Semester	char(5)=NULL
AS
	IF @CourseId is NULL OR @Semester IS NULL
		BEGIN
		RAISERROR ('CourseID and Semester is Required',16,1)
		END
	ELSE
	SELECT	C.CourseName,
			FirstName + ' ' + LastName AS 'FullName',
			R.Mark
	FROM	Student S
		INNER JOIN Registration R
			ON R.StudentID = S.StudentID
		INNER JOIN Course C
			ON C.CourseId = R.CourseID
	WHERE C.CourseID = @CourseID AND R.Semester = @Semester
RETURN

EXECUTE Attendance 'DMIT103', '2000S'

-- 7. The school is running out of money! Find out who still owes money for the courses they are enrolled in.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'GiveMeMoney')
    DROP PROCEDURE GiveMeMoney
GO
CREATE PROCEDURE GiveMeMoney
AS
	SELECT	S.StudentID,
			FirstName + ' ' + LastName AS 'FullName',
			C.CourseName,
			S.BalanceOwing
	FROM	Student S
		INNER JOIN Registration R
			ON R.StudentID = S.StudentID
		INNER JOIN Course C
			ON C.CourseId = R.CourseID
	WHERE	S.BalanceOwing > 0
RETURN

EXECUTE	GiveMeMoney
GO
-- Stored Procedure (Sprocs) Exercises

-- Take the following queries and turn them into stored procedures.

-- 1.   Selects the studentID's, CourseID and mark where the Mark is between 70 and 80
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ListStudentMarksByRange')
    DROP PROCEDURE ListStudentMarksByRange
GO
CREATE PROCEDURE ListStudentMarksByRange
	@HighMark	int,
	@LowMark	int
AS
	IF @LowMark < 70 OR @HighMark > 80
		BEGIN
		RAISERROR ('Mark must be between 80-70',16,1)
		END
	ELSE
	SELECT  StudentID, CourseId, Mark
	FROM    Registration
	WHERE   Mark BETWEEN @LowMark AND @HighMark
RETURN
GO
--      Place this in a stored procedure that has two parameters,
--      one for the upper value and one for the lower value.
--      Call the stored procedure ListStudentMarksByRange
EXECUTE ListStudentMarksByRange 81, 72


/* ----------------------------------------------------- */

-- 2.	Selects the Staff full names and the Course ID's they teach.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CourseInstructors')
    DROP PROCEDURE CourseInstructors
GO
CREATE PROCEDURE CourseInstructors
AS
	SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
			FirstName + ' ' + LastName AS 'Staff Full Name',
			CourseId
	FROM    Staff S
		INNER JOIN Registration R
			ON S.StaffID = R.StaffID
	ORDER BY 'Staff Full Name', CourseId
RETURN
GO
--      Place this in a stored procedure called CourseInstructors.
EXECUTE CourseInstructors

/* ----------------------------------------------------- */

-- 3.   Selects the students first and last names who have last names starting with S.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindStudentByLastName')
    DROP PROCEDURE FindStudentByLastName
GO
CREATE PROCEDURE FindStudentByLastName
	@PartialName	varchar(20)
AS
	IF @PartialName IS NULL
		BEGIN
		RAISERROR ('Name must be included and start with an S',16,1)
		END
	ELSE
	SELECT  FirstName, LastName
	FROM    Student
	WHERE  LastName LIKE @PartialName + '%'
RETURN
GO
--      Place this in a stored procedure called FindStudentByLastName.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable;
--      Your solution should concatenate the @PartialName with the wildcard.
EXECUTE FindStudentByLastName 'sm'

/* ----------------------------------------------------- */

-- 4.   Selects the CourseID's and Coursenames where the CourseName contains the word 'programming'.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindCourse')
    DROP PROCEDURE FindCourse
GO
CREATE PROCEDURE FindCourse
	@PartialName	varchar(20)
AS
	IF @PartialName IS NULL
		BEGIN
		RAISERROR ('Partial name is required',16,1)
		END
	ELSE
	SELECT  CourseId, CourseName
	FROM    Course
	WHERE  CourseName LIKE '%' + @PartialName + '%'
RETURN
GO
--      Place this in a stored procedure called FindCourse.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable.

EXECUTE FindCourse 'Program'

/* ----------------------------------------------------- */

-- 5.   Selects the Payment Type Description(s) that have the highest number of Payments made.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'MostFrequentPaymentTypes')
    DROP PROCEDURE MostFrequentPaymentTypes
GO
CREATE PROCEDURE MostFrequentPaymentTypes
AS
	SELECT PaymentTypeDescription
	FROM   Payment 
		INNER JOIN PaymentType 
			ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
	GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
	HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
RETURN
GO
--      Place this in a stored procedure called MostFrequentPaymentTypes.
EXECUTE MostFrequentPaymentTypes
GO

-- More Stored Procedure (Sprocs) Exercises

-- 1. Create a stored procedure called AddPosition that will accept a Position Description (varchar 50). Return the primary key value that was database-generated as a result of your Insert statement. Also, ensure that the supplied description is not NULL and that it is at least 5 characters long. Make sure that you do not allow a duplicate position name.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'AddPosition')
    DROP PROCEDURE AddPosition
GO
CREATE PROCEDURE AddPosition
    -- Parameters here
    @Description    varchar(50)
AS
    -- Body of procedure here
    IF @Description IS NULL
    BEGIN -- {
        RAISERROR('Description is required', 16, 1) -- Throw an exception
    END   -- }
    ELSE
    BEGIN -- {
        IF LEN(@Description) < 5
        BEGIN -- {
            RAISERROR('Description must be between 5 and 50 characters', 16, 1)
        END   -- }
        ELSE
        BEGIN -- {
            IF EXISTS(SELECT * FROM Position WHERE PositionDescription = @Description)
            BEGIN -- {
                RAISERROR('Duplicate positions are not allowed', 16, 1)
            END   -- }
            ELSE
            BEGIN -- {
                INSERT INTO Position(PositionDescription)
                VALUES (@Description)
                -- Send back the database-generated primary key
                SELECT @@IDENTITY -- This is a global variable
            END   -- }
        END   -- }
    END   -- }
RETURN
GO

-- Let's test our AddPosition stored procedure

EXEC AddPosition 'The Boss'
EXEC AddPosition NULL -- This should result in an error being raised
EXEC AddPosition 'Me' -- This should result in an error being raised
EXEC AddPosition 'The Boss' -- This should result in an error as well (a duplicate)
GO

-- 2) Create a stored procedure called LookupClubMembers that takes a club ID and returns the full names of all members in the club.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'LookupClubMembers')
    DROP PROCEDURE LookupClubMembers
GO
CREATE PROCEDURE LookupClubMembers
    -- Parameters here
    @ClubId     varchar(10)
AS
    -- Body of procedure here
    IF @ClubId IS NULL OR NOT EXISTS(SELECT * FROM Club WHERE ClubId = @ClubId)
    BEGIN
        RAISERROR('ClubID is invalid/does not exist', 16, 1)
    END
    ELSE
    BEGIN
        SELECT  FirstName + ' ' + LastName AS 'MemberName'
        FROM    Student S
            INNER JOIN Activity A ON A.StudentID = S.StudentID
        WHERE   A.ClubId = @ClubId
    END
RETURN
GO

-- Test the above sproc
EXEC LookupClubMembers 'CHESS'
EXEC LookupClubMembers 'CSS'
EXEC LookupClubMembers 'Drop Out'
EXEC LookupClubMembers 'NASA1'
EXEC LookupClubMembers NULL

-- 3) Create a stored procedure called RemoveClubMembership that takes a club ID and deletes all the members of that club. Be sure that the club exists. Also, raise an error if there were no members deleted from the club.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'RemoveClubMembership')
    DROP PROCEDURE RemoveClubMembership
GO
CREATE PROCEDURE RemoveClubMembership
    -- Parameters here
    @ClubId     varchar(10)
AS
    -- Body of procedure here
    IF @ClubId IS NULL OR NOT EXISTS(SELECT * FROM Club WHERE ClubId = @ClubId)
    BEGIN
        RAISERROR('ClubID is invalid/does not exist', 16, 1)
    END
    ELSE
    BEGIN
        DELETE FROM Activity
        WHERE       ClubId = @ClubId
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No members were deleted', 16, 1)
        END
    END
RETURN
GO
-- Test the above sproc...
EXEC RemoveClubMembership NULL
EXEC RemoveClubMembership 'Drop Out'
EXEC RemoveClubMembership 'NASA1'
EXEC RemoveClubMembership 'CSS'
EXEC RemoveClubMembership 'CSS' -- The second time this is run, there will be no members to remove


-- 4) Create a stored procedure called OverActiveMembers that takes a single number: ClubCount. This procedure should return the names of all members that are active in as many or more clubs than the supplied club count.
--    (p.s. - You might want to make sure to add more members to more clubs, seeing as tests for the last question might remove a lot of club members....)



-- 5) Create a stored procedure called ListStudentsWithoutClubs that lists the full names of all students who are not active in a club.



-- 6) Create a stored procedure called LookupStudent that accepts a partial student last name and returns a list of all students whose last name includes the partial last name. Return the student first and last name as well as their ID.

