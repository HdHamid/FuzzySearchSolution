--Exec Common.EradicateExtraSpaces @ColId = N'ID',@ColName = 'Name',@TableName = N'[Test01]..Names'
CREATE Procedure Common.EradicateExtraSpaces
@ColId nvarchar(Max) = N'ID'
,@ColName Nvarchar(MAX) 
,@TableName  Nvarchar(MAX) 
as 
Declare @SqlString Nvarchar(MAX) = 
N'
select '+@ColId+',
REPLACE(
            REPLACE(
                REPLACE(
                    LTRIM(RTRIM('+@ColName+'))
                ,''  '','' ''+char(7)) 
            ,char(7)+'' '','''')    
        ,CHAR(7),'''') as '+@ColName+'_New
from '+@TableName+'
'
exec(@SqlString)

