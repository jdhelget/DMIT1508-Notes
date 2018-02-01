# Introduction to SQL

- SQL stands for Structured Query Language.
- Information Comes in 3 natural forms: Textual, Numeric, and Conceptual.
- When it comes to SQL Some examples of these are:
**Textual:** 
- char - Fixed length string.
- varchar - variable length string.
- text - length is set to the maximum
- nchar - fixed length string for international characters
- nvarchar - variable length string for international characters
**Numeric:**
- int - whole number type, holds 4bytes
- smallint - holds a smaller number, 2bytes
- bigint - holds a bigger number, 8bytes
- tinyint - holds an even smaller number, 1byte
- decimal
- real
- float
- numberic - money/smallmoney
**Conceptual:**
- bit - can be 0 or 1
- datetime - refers to a date and time
- smalldatetime - refers to date and time with smaller values
- datetime2 - if you wish to reference a date before the gregorian calendar
- image - for storing images
- binary - fixed number of bytes.
- varbinary - fixed variable of bytes.

- DDL stands for Data Definition Language.
- An example of an SQL table is as follows
CREATE TABLE TableName -- Use a plural name for your tables
(
    -- Column Definitions - comma seperated list of column definitions & table constraints
)
----------
ColumnName datatype [NULL/NOT NULL]
    [Constraints]