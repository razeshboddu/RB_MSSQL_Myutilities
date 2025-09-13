SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Syntax: dbo.udf_getarrayvalueatindex(Input_CharField,index,delimiter) */

CREATE FUNCTION [dbo].[udf_GetArrayValueAtIndex]
(
    @InputString NVARCHAR(MAX),
    @Index INT,
	@delimiter varchar(10) = ','
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX)
    
    ;WITH CTE AS
    (
        SELECT 
            value, 
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM STRING_SPLIT(@InputString, @delimiter)
    )
    SELECT @Result = value FROM CTE WHERE rn = @Index

    RETURN @Result
END
GO

/*

Example:

Select dbo.udf_getarrayvalueatindex(('abc;def;ghi;jkl'),2,';')
Output: def
*/
