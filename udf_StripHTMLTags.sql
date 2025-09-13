/****** Object:  UserDefinedFunction [dbo].[StripHTML]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[StripHTML] (@InputText VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @OutputText VARCHAR(MAX);
    SET @OutputText = @InputText;
    
    WHILE CHARINDEX('<', @OutputText) > 0 AND CHARINDEX('>', @OutputText) > CHARINDEX('<', @OutputText)
    BEGIN
        SET @OutputText = STUFF(@OutputText, CHARINDEX('<', @OutputText),
                                CHARINDEX('>', @OutputText) - CHARINDEX('<', @OutputText) + 1, '');
    END
    
    RETURN @OutputText;
END;
GO
