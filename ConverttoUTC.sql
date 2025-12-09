--Sql function to convert date to UTC format

ALTER    FUNCTION [dbo].[UTC_DateTime](@DTIn DateTime) RETURNS DateTime as
BEGIN
Declare @DTReturn  datetime ;
set @DTReturn =  dateadd(hour,-4, @DTIn)
  RETURN @DTReturn
END
