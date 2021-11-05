--exec Common.InsertPhrase @ColId = N'ID',@ColName = 'Description',@TableName = N'[Test01]..Names'
CREATE Procedure [Common].[InsertPhrase] 
@ColId nvarchar(Max),@ColName nvarchar(Max),@TableName nvarchar(Max)
as 
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
           Drop table if exists #Stp1
           Create table #Stp1 (ID int,Txt nvarchar(Max))
           insert into #Stp1(ID, Txt)
           Exec Common.EradicateExtraSpaces @ColId = @ColId,@ColName = @ColName,@TableName = @TableName
           
           delete #Stp1 where Txt is null 
           
           Drop table if exists #Stp2
           select n.id,s.value as Txt into #Stp2 from #Stp1 n  cross apply  string_split(n.Txt,N' ') s
           
           
           Drop table if exists #Stp3
           select n.id,s.value as Txt into #Stp3 from #Stp2 n cross apply string_split(n.Txt,N'،') s
           
           delete #Stp3 where Txt = N'' or txt is null 
           
           
           Update N 
           set n.Txt = Replace(n.Txt,B.Chars,N'')  
           from  #Stp3 N INNER join Common.IgnoredChars B on n.Txt like IIF(b.EscapedChar = 1,N'%['+b.Chars+']%', N'%'+B.Chars+'%') and b.step = 1
           
           delete #Stp3 where Txt = N'' or txt is null 
           
           Update N 
           set n.Txt = Replace(n.Txt,B.Chars,N'')  
           from  #Stp3 N INNER join Common.IgnoredChars B on n.Txt like IIF(b.EscapedChar = 1,N'%['+b.Chars+']%', N'%'+B.Chars+'%') and b.step = 2
           
           
           delete #Stp3 where Txt = N'' or txt is null 
           
           Delete s from #Stp3 s inner join Common.Conjunctions c on c.words = s.Txt
           
           
           insert into [Common].[Phrases](Phrase)
           select txt from #Stp3 s where not exists (select 1 from [Common].[Phrases] p where p.Phrase = s.Txt)
           group by txt 
           
           
           
           insert into [Common].PhraseSourceRelation(SourceId,PhrasaeId)
           select s.ID as SourceId,p.Id as PhrasaeId from [Common].[Phrases] P inner join #Stp3 s on s.Txt = p.phrase 
           where not exists(select 1 from [Common].PhraseSourceRelation ii where ii.SourceId = s.ID and ii.PhrasaeId = p.id)
           group by s.ID,p.Id
COMMIT TRANSACTION		
END TRY
BEGIN CATCH
	exec Common.ErrorHandling

-- Transaction uncommittable
    IF (XACT_STATE()) = -1
      ROLLBACK TRANSACTION
 
-- Transaction committable
    IF (XACT_STATE()) = 1
      COMMIT TRANSACTION
END CATCH;
END