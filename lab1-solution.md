# Lab 1 Solution Key

------------------------

## Employee View

## 0NF
Employee (EmployeeNumber, SIN, FirstName, LastName, Address, City, Province, PostalCode, HomePhone, WorkPhone, Email, EmployeeGroupCode, EmployeeGroupName, Wage)

## 1NF
No Changes - No reapeating data

## 2NF
No Changes

## 3NF
Employee (PK - EmployeeNumber, SIN, FirstName, LastName, Address, City, Province, PostalCode, HomePhone, WorkPhone, Email, FK - EmployeeGroupCode)

Employee Group (PK - EmployeeGroupCode, EmployeeGroupName, Wage)

----------------------

## Book Title View

## 0NF
Book (ISBN, Title, Selling Price, Stock, Publisher Code, Publisher Name, {Author Code, Author FirstName, Author LastName}, Category Code, Category Description)

## 1NF

Book (PK - ISBN, Title, Selling Price, Stock, Publisher Code, Publisher Name, Category Code, Category Description)

Book Author (PK, FK - ISBN, PK - Author Code, Author FirstName, Author LastName)

## 2NF

Book (PK - ISBN, Title, Selling Price, Stock, Publisher Code, Publisher Name, Category Code, Category Description)

Book Author (PK, FK - ISBN, PK, FK - AuthorCode)

Author (PK - Author Code, FirstName, LastName)

## 3NF

Book (PK - ISBN, Title, Selling Price, Stock, FK - Publisher Code, FK - Category Code)

Book Author (PK, FK - ISBN, PK, FK - AuthorCode)

Author (PK - Author Code, FirstName, LastName)

Publisher (PK - Publisher Code, Publisher Name)

Category (PK - Category Code, Category Description)

------------------

## Sale View

## 0NF
Sale (SaleNumber, Date, Customer FirstName, LastName, Address, City, Province, PostalCode, CustomerNumber, Employee FirstName, LastName, EmployeeNumber, {ISBN, BookTitle, Price, Quantity, Amount}, Subtotal, GST, Total)

## 1NF
Sale (PK - SaleNumber, Date, Customer FirstName, LastName, Address, City, Province, PostalCode, CustomerNumber, Employee FirstName, LastName, EmployeeNumber, Subtotal, GST, Total)

Sale Details (PK, FK - SaleNumber, PK - ISBN, BookTitle, Price, Quantity, Amount)

## 2NF
Sale (PK - SaleNumber, Date, Customer FirstName, LastName, Address, City, Province, PostalCode, CustomerNumber, Employee FirstName, LastName, EmployeeNumber, Subtotal, GST, Total)

Sale Details (PK, FK - SaleNumber, PK, FK - ISBN, Price, Quantity, Amount)

Book (PK - ISBN, BookTitle)

## 3NF
Sale (PK - SaleNumber, Date, FK - CustomerNumber, FK - EmployeeNumber, Subtotal, GST, Total)

Sale Details (PK, FK - SaleNumber, PK, FK - ISBN, Price, Quantity, Amount)

Book (PK - ISBN, BookTitle)

Customer (PK - CustomerNumber, FirstName, LastName, Address, City, Province, PostalCode)

Employee (PK - EmployeeNumber, FirstName, LastName)