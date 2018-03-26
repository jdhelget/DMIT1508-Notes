IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Movie')
    DROP TABLE Movie
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Genres')
    DROP TABLE Genres
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Actor')
    DROP TABLE Actor
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Director')
    DROP TABLE Director
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Movie Direction')
    DROP TABLE MovieDirection
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Movie Cast')
    DROP TABLE MovieCast
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Movie Genres')
    DROP TABLE MovieGenres
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reviewer')
    DROP TABLE Reviewer
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Rating')
    DROP TABLE Rating

CREATE TABLE Movie
(
    MovieId         int
        CONSTRAINT PK_Movie_MovieId
            PRIMARY KEY
        IDENTITY(901,1)         NOT NULL,
    Title           char(50)    NOT NULL,
    Year            int         
        CONSTRAINT CK_Movie_MovieYear
            CHECK (MovieYear LIKE [0-9][0-9][0-9][0-9])
                                NOT NULL,
    Length          int         NOT NULL,
    Language        char(50)    
        CONSTRAINT DF_Movie_MovieLanguage
            DEFAULT ('English') NOT NULL,
    ReleaseDate     date            NULL,
    ReleaseCountry char(5)          NULL  
)
CREATE TABLE Genres
(
    GenreID         int
        CONSTRAINT PK_Genres_GenreID
            PRIMARY KEY
        IDENTITY(1,1)           NOT NULL,
    GenreTitle      Char(20)    NOT NULL
)
CREATE TABLE Actor
(
    ActorID         int
        CONSTRAINT PK_Actor_ActorID
            PRIMARY KEY
        IDENTITY(100,1)         NOT NULL,
    FirstName       char(20)    NOT NULL,
    LastName        char(20)    NOT NULL,
    Gender          char(1)     
        CONSTRAINT CK_Actor_Gender
            CHECK (Gender LIKE 'm' OR 'f')
                                NOT NULL
)
CREATE TABLE Director
(
    DirectorID      int
        CONSTRAINT PK_Director_DirectorID
            PRIMARY KEY
    IDENTITY(100,1)             NOT NULL,
    FirstName       char(20)    NOT NULL,
    LastName        char(20)    NOT NULL
)
CREATE TABLE MovieDirection
(
    DirectorID      int
        CONSTRAINT FK_MovieDirection_DirectorID_Director_DirectorID
            FOREIGN KEY REFERENCES Director(DirectorID)
                                NOT NULL,
    MovieId         int
        CONSTRAINT FK_MovieDirection_MovieID_Movie_MovieID
            FOREIGN KEY REFERENCES Movie(MovieId)
                                NOT NULL
        CONSTRAINT PK_MovieDirection_DirectorID_MovieID
            PRIMARY KEY (DirectorID, MovieID)
)
CREATE TABLE MovieCast
(
    ActorID         int
        CONSTRAINT FK_MovieCast_ActorID_Actor_ActorID
            FOREIGN KEY REFERENCES Actor(ActorID)
                                NOT NULL,
    MovieId         int
        CONSTRAINT FK_MovieCast_MovieID_Movie_MovieID
            FOREIGN KEY REFERENCES Movie(MovieId)
                                NOT NULL,
    Role            char(30)    NOT NULL
        CONSTRAINT PK_MovieCast_ActorID_MovieID
            PRIMARY KEY (ActorID, MovieID)
)
CREATE TABLE MovieGenres
(
    MovieID         int
        CONSTRAINT FK_MovieGenres_MovieID_Movie_MovieID
            FOREIGN KEY REFERENCES Movie(MovieID)
                                NOT NULL,
    GenreID         int
        CONSTRAINT FK_MovieGenres_GenreID_Genres_GenreID
            FOREIGN KEY REFERENCES Genres(GenreID)
                                NOT NULL
)
CREATE TABLE Reviewer
(
    ReviewerID      int
        CONSTRAINT PK_Reviewer_ReviewerID
            PRIMARY KEY         NOT NULL,
    ReviewerName    char(30)    NOT NULL
)
CREATE TABLE Rating
(
    MovieID         int
        CONSTRAINT FK_Rating_MovieID_Movie_MovieID
            FOREIGN KEY REFERENCES Movie(MovieID)
                                NOT NULL,
    ReviewerID      int
        CONSTRAINT FK_Rating_ReviewerID_Reviewer_ReviewerID
            FOREIGN KEY REFERENCES Reviewer(ReviewerID)
                                NOT NULL,
    ReviewStars     int         
        CONSTRAINT CK_Rating_ReviewStars
            CHECK (ReviewStars BETWEEN 1 AND 5)
                                NOT NULL,
    NumberOfRatings int         NOT NULL
        CONSTRAINT PK_Rating_MovieID_ReviewerID
            PRIMARY KEY (MovieID, ReviewerID)
)
GO

INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Vertigo', 1958, 128, 1958-08-24, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('The Innocents', 1961, 100, 1962-02-19, 'SW')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Lawrence of Arabia', 1962, 216, 1962-12-11, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('The Deer Hunter', 1978, 183, 1979-03-08, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Amadeus', 1984, 160, 1985-01-07, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Blade Runner', 1982, 117, 1982-09-09, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Eyes Wide Shut', 1999, 159, NULL, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('The Usual Suspects', 1995, 106, 1995-08-25, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Chinatown', 1974, 130, 1974-08-09, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Boogie Nights', 1997, 155, 1998-02-16, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Annie Hall', 1977, 93, 1977-04-20, 'USA')
INSERT INTO Movie(Title, Year, Length, Language, ReleaseDate, ReleaseCountry)
    VALUES('Princess Mononoke', 1997, 134, 'Japanese', 2001-10-19, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('The Shawshank Redemption', 1994, 142, 1995-02-17, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('American Beauty', 1999, 122, NULL, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Titanic', 1997, 194, 1998-01-23, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Good Will Hunting', 1997, 126, 1998-06-03, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Deliverance', 1972, 109, 1982-10-05, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Trainspotting', 1996, 94, 1996-02-23, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('The Prestige', 2006, 130, 2006-11-10, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Donnie Darko', 2001, 113, NULL, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Slumdog Millionaire', 2008, 120, 2009-01-09, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Aliens', 1986, 137, 1986-08-29, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Beyond the Sea', 2004, 118, 2004-11-26, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Avatar', 2009, 162, 2009-12-17, 'UK')
INSERT INTO Movie(Title, Year, Length, Language, ReleaseDate, ReleaseCountry)
    VALUES('Seven Samurai', 1954, 207, 'Japanese', 1954-04-26, 'JP')
INSERT INTO Movie(Title, Year, Length, Language, ReleaseDate, ReleaseCountry)
    VALUES('Spirited Away', 2001, 125, 'Japanese', 2003-09-12, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Back to the Future', 1985, 116, 1985-12-04, 'UK')
INSERT INTO Movie(Title, Year, Length, ReleaseDate, ReleaseCountry)
    VALUES('Braveheart', 1995, 178, 1995-09-08, 'UK')
    