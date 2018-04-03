-- Triggers Samples
USE [A01-School]
GO

/* ***********************************************
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Table_TriggerType]'))
    DROP TRIGGER Table_TriggerType
GO

CREATE TRIGGER Table_TriggerType
ON TableName
FOR Insert,Update,Delete -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
RETURN
GO
******************************************** */

-- Make a diagnostic trigger
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Activity_DML_Diagnostic]'))
    DROP TRIGGER Activity_DML_Diagnostic
GO

CREATE TRIGGER Activity_DML_Diagnostic
ON Activity
FOR Insert,Update,Delete
AS
	-- Body of Trigger
    SELECT 'Activity Table:', StudentID, ClubId FROM Activity ORDER BY StudentID
    SELECT 'Inserted row:'  , StudentID, ClubId FROM inserted ORDER BY StudentID
    SELECT 'Deleted row:'   , StudentID, ClubId FROM deleted  ORDER BY StudentID
RETURN
GO


-- Demonstrate the diagnostic trigger
INSERT INTO Activity(StudentID, ClubId) VALUES (200494476, 'CIPS')
UPDATE Activity SET ClubId = 'NASA1' WHERE StudentID = 200494476
DELETE FROM Activity WHERE StudentID = 200494476

GO
-- Disable a trigger
DISABLE TRIGGER Activity_DML_Diagnostic ON Activity


/* ---------------------------------------------*/

--1.	In order to be fair to all students, a student can only belong to a maximum of 3 clubs. Create a trigger to enforce this rule.
-- See who is in a club and how many clubs they are in...
SELECT  FirstName, LastName, COUNT(ClubId) AS 'Number of clubs'
FROM    Student S INNER JOIN Activity A ON S.StudentID = A.StudentID
GROUP BY FirstName, LastName
ORDER BY 'Number of clubs' DESC

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Activity_InsertUpdate]'))
    DROP TRIGGER Activity_InsertUpdate
GO
-- sp_help Activity
CREATE TRIGGER Activity_InsertUpdate
ON Activity
FOR Insert,Update -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    DECLARE @StudentCount int
    SELECT @StudentCount = Count(ClubID) FROM Activity
    WHERE StudentID IN (Select StudentID from inserted)
    PRINT(@StudentCount) -- Simple Diagnostics

    -- Head's Up! This IF statement is incorrect - The "Why?" will follow...
    IF @StudentCount > 3
    BEGIN
        RAISERROR('Max of 3 clubs that a student can belong to', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO
-- The above trigger is invoked after either an Insert or an Update
-- The following test should result in a rollback.
INSERT INTO Activity(StudentID, ClubId)
VALUES (200495500, 'CIPS') -- Robert Smith
/* The following INSERTED/DELETED tables look like this...
inserted                        deleted
________________________        ________________________
| StudentID | ClubID   |        | StudentID | ClubID   |
========================        ========================
| 200495500 | 'CIPS'   |        ------------------------
------------------------        ## No rows
## 1 Row

---------------------------------------------------------
exploring...
DECLARE @StudentCount int
SELECT @StudentCount = Count(ClubID) FROM Activity
WHERE StudentID IN (200495500)
PRINT(@StudentCount)
*/
-- The following student should be added...
INSERT INTO Activity(StudentID, ClubId)
VALUES (200312345, 'CIPS') -- Mary Jane

-- Why did the following fail????
INSERT INTO Activity(StudentID, ClubId)
VALUES (199899200, 'CIPS'), -- Ivy Kent
       (200322620, 'CIPS')  -- Flying Nun


-- Why will the following succeed when the previous failed????
INSERT INTO Activity(StudentID, ClubId)
VALUES (200122100, 'CIPS'), -- Peter Codd
       (200494476, 'CIPS'), -- Joe Cool
       (200522220, 'CIPS'), -- Joe Petroni
       (200978400, 'CIPS'), -- Peter Pan
       (200688700, 'CIPS')  -- Robbie Chan


-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Here is how the trigger SHOULD have been written
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Activity_InsertUpdate]'))
    DROP TRIGGER Activity_InsertUpdate
GO
-- sp_help Activity
CREATE TRIGGER Activity_InsertUpdate
ON Activity
FOR Insert,Update -- Run this trigger for any INSERT or UPDATE on the Activity table
AS
	-- Body of Trigger
    IF @@ROWCOUNT > 0 AND
       EXISTS (SELECT * FROM Activity A INNER JOIN inserted I ON A.StudentID = I.StudentID
               GROUP BY I.StudentID HAVING COUNT(*) > 3)
    BEGIN
        RAISERROR('Max of 3 clubs that a student can belong to', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO



--2.	The Education Board is concerned with rising course costs! Create a trigger to ensure that a course cost does not get increased by more than 20% at any one time.
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Course_Update_CourseCostLimit]'))
    DROP TRIGGER Course_Update_CourseCostLimit
GO

CREATE TRIGGER Course_Update_CourseCostLimit
ON Course
FOR Update -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    IF EXISTS (SELECT * FROM inserted I INNER JOIN deleted D ON I.CourseId = D.CourseId
               WHERE I.CourseCost > D.CourseCost * 1.20)
    BEGIN
        RAISERROR('Students can''t afford that much of an increase!', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO
-- TODO: Write the code that will test this stored procedure.
-- quick check of the courses & costs
select * from course
UPDATE Course SET CourseCost = 541 WHERE CourseId = 'DMIT103'
-- test with good data
UPDATE Course SET CourseCost = 540 WHERE CourseID = 'DMIT103'
-- try another one
UPDATE Course SET CourseCost = 600

--3.	Too many students owe us money and keep registering for more courses! Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of >$500.
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Registration_Insert_BalanceOwing]'))
    DROP TRIGGER Registration_Insert_BalanceOwing
GO

CREATE TRIGGER Registration_Insert_BalanceOwing
ON Registration
FOR Insert -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    IF @@ROWCOUNT > 0 AND
       EXISTS(SELECT * FROM inserted I INNER JOIN Student S ON I.StudentID = S.StudentID
              WHERE S.BalanceOwing > 500)
    BEGIN
        RAISERROR('Student owes too much money - cannot register student in course', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO

-- TODO: Student, write code to test this trigger
INSERT INTO Registration (StudentID, CourseID, Semester)
VALUES	(200122100, 'DMIT103', '2000s')

--4. Our school DBA has suddenly disabled some Foreign Key constraints to deal with performance issues! Create a trigger on the Registration table to ensure that only valid CourseIDs, StudentIDs and StaffIDs are used for grade records. (You can use sp_help tablename to find the name of the foreign key constraints you need to disable to test your trigger.) Have the trigger raise an error for each foreign key that is not valid. If you have trouble with this question create the trigger so it just checks for a valid student ID.
-- sp_help Registration -- then disable the foreign key constraints....
ALTER TABLE Registration NOCHECK CONSTRAINT FK_GRD_CRS_CseID
ALTER TABLE Registration NOCHECK CONSTRAINT FK_GRD_STF_StaID
ALTER TABLE Registration NOCHECK CONSTRAINT FK_GRD_STU_StuID
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Registration_InsertUpdate_EnforceForeignKeyValues]'))
    DROP TRIGGER Registration_InsertUpdate_EnforceForeignKeyValues
GO

CREATE TRIGGER Registration_InsertUpdate_EnforceForeignKeyValues
ON Registration
FOR Insert,Update -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    IF @@ROWCOUNT > 0
    BEGIN
        -- UPDATE(columnName) is a function call that checks to see if information between the 
        -- deleted and inserted tables for that column are different (i.e.: data in that column
        -- has changed).
        IF UPDATE(StudentID) AND
           NOT EXISTS (SELECT * FROM inserted I INNER JOIN Student S ON I.StudentID = S.StudentID)
        BEGIN
            RAISERROR('That is not a valid StudentID', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        IF UPDATE(CourseID) AND
           NOT EXISTS (SELECT * FROM inserted I INNER JOIN Course C ON I.CourseId = C.CourseId)
        BEGIN
            RAISERROR('That is not a valid CourseID', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        IF UPDATE(StaffID) AND
           NOT EXISTS (SELECT * FROM inserted I INNER JOIN Staff S ON I.StaffID = S.StaffID)
        BEGIN
            RAISERROR('That is not a valid StaffID', 16, 1)
            ROLLBACK TRANSACTION
        END
    END
RETURN
GO

-- 5. The school has placed a temporary hold on the creation of any more clubs. (Existing clubs can be renamed or removed, but no additional clubs can be created.) Put a trigger on the Clubs table to prevent any new clubs from being created.
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Club_Insert_Lockdown]'))
    DROP TRIGGER Club_Insert_Lockdown
GO

CREATE TRIGGER Club_Insert_Lockdown
ON Club
FOR Insert -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    IF @@ROWCOUNT > 0
    BEGIN
        RAISERROR('Temporary lockdown on creating new clubs.', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO

-- 6. Our network security officer suspects our system has a virus that is allowing students to alter their balance owing records! In order to track down what is happening we want to create a logging table that will log any changes to the balance owing in the Student table. You must create the logging table and the trigger to populate it when the balance owing is modified.
-- Step 1) Make the logging table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BalanceOwingLog')
    DROP TABLE BalanceOwingLog
GO
CREATE TABLE BalanceOwingLog
(
    LogID           int  IDENTITY (1,1) NOT NULL CONSTRAINT PK_BalanceOwingLog PRIMARY KEY,
    ChangeDateTime  datetime            NOT NULL,
    OldBalance      decimal (7,2)       NOT NULL,
    NewBalance      decimal (7,2)       NOT NULL
)
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Student_Update_AuditBalanceOwing]'))
    DROP TRIGGER Student_Update_AuditBalanceOwing
GO

CREATE TRIGGER Student_Update_AuditBalanceOwing
ON Student
FOR Update -- Choose only the DML statement(s) that apply
AS
	-- Body of Trigger
    IF @@ROWCOUNT > 0 AND UPDATE(BalanceOwing)
	BEGIN
	    INSERT INTO BalanceOwingLog (ChangedateTime,OldBalance,NewBalance)
	    SELECT GETDATE(), D.BalanceOwing, I.BalanceOwing
        FROM deleted D INNER JOIN inserted I on D.StudentID = I.StudentID
	    IF @@ERROR <>0 
	    BEGIN
		    RAISERROR('Insert into BalanceOwingLog Failed',16,1)
            ROLLBACK TRANSACTION
		END	
	END
RETURN
GO

-- 7.Create a trigger on the Staff table that ensures Staff members are only added one-at-a-time. Call this trigger "Staff_Insert_Limit"
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Staff_Insert_Limit]'))
    DROP TRIGGER Staff_Insert_Limit
GO
CREATE TRIGGER Staff_Insert_Limit
ON Staff
FOR INSERT
AS
	IF @@ROWCOUNT > 0 AND
        EXISTS (SELECT * FROM inserted I HAVING COUNT(I.StaffID) > 1)
		BEGIN
		RAISERROR('Only one staff member can be added at a time',16,1)
		ROLLBACK TRANSACTION
		END
RETURN
GO

INSERT INTO Staff(FirstName, LastName, DateHired, PositionID, LoginID)
VALUES	('Ned', 'Stark', GETDATE(), 4, NULL),
		('Robert', 'Baratheon', GETDATE(), 5, NULL)

-- 8.Create a trigger on the Staff table so that when a new staff member is added, a rollback occurs if the change results in more than one person in the "Dean" position.
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Staff_Insert_Dean]'))
    DROP TRIGGER Staff_Insert_Dean
GO
CREATE TRIGGER Staff_Insert_Dean
ON Staff
FOR INSERT
AS
	IF @@ROWCOUNT > 0 AND
		EXISTS (SELECT PositionID FROM Staff WHERE PositionID = 1)
		BEGIN
		RAISERROR ('There can only be one Dean at a time',16,1)
		ROLLBACK TRANSACTION
		END
RETURN
GO

INSERT INTO Staff(FirstName, LastName, DateHired, PositionID, LoginID)
VALUES	('Ned', 'Stark', GETDATE(), 1, NULL)
DELETE FROM Staff
WHERE FirstName = 'Ned'