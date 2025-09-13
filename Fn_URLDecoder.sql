/****** Object:  UserDefinedFunction [dbo].[udf_URLDecode]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_URLDecode]
(
    @URL VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @Position INT,
        @Base CHAR(16),
        @High TINYINT,
        @Low TINYINT,
        @Pattern CHAR(21)

    SELECT  @Base = '0123456789abcdef',
        @Pattern = '%[%][0-9a-f][0-9a-f]%',
        @URL = REPLACE(@URL, '+', ' '),
        @Position = PATINDEX(@Pattern, @URL)

    WHILE @Position > 0
        SELECT  @High = CHARINDEX(SUBSTRING(@URL, @Position + 1, 1), @Base COLLATE Latin1_General_CI_AS),
            @Low = CHARINDEX(SUBSTRING(@URL, @Position + 2, 1), @Base COLLATE Latin1_General_CI_AS),
            @URL = STUFF(@URL, @Position, 3, CHAR(16 * @High + @Low - 17)),
            @Position = PATINDEX(@Pattern, @URL)

    RETURN  @URL
END

GO

