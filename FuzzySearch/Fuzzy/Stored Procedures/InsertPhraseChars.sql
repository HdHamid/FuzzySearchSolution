--exec Fuzzy.InsertPhraseChars
CREATE Procedure [Fuzzy].[InsertPhraseChars]
as 
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

			Drop table if exists #Stp1
			;with stp1 as 
			(
				select n.ID,n.phrase,len(n.phrase)Ln,substring(n.phrase,1,1) as Chr,1 as CharPlace from [Common].[Phrases] n where isprocessed = 0
				union all 
				select n.ID,n.phrase,s.Ln - 1,substring(n.phrase,1+s.CharPlace,1) as Strng,1+s.CharPlace as CharPlace
				from [Common].[Phrases] n inner join stp1 s on s.ID = n.ID
				where s.Ln-1 > 0 
			)
			select * into #Stp1 from stp1
			
			
			Drop table if exists #Res
			;With stp2 as 
			(
				select s.ID as PhraseId,e.ID as CharId,len(phrase) as LenString,CharPlace from #Stp1 s inner join Common.Alphabet e on e.Chars = s.Chr
			)
			, stp3 as 
			(
				select *,cast(cast(CharId as varchar(50))+cast(CharPlace as varchar(50)) as int) as UnqNn from stp2
			) 
			select * into #Res from stp3 
			
			
			Insert into Fuzzy.PhraseChars(PhraseId,CharId,Lenstring,CharPlace,UnqNn)
			select PhraseId,CharId,Lenstring,CharPlace,UnqNn 
			from #Res R
			where not exists(select 1 from Fuzzy.PhraseChars Pc where PC.PhraseId= R.PhraseId)
			
			Drop Table if exists #PhraseIdProcessed 
			select Distinct ID into #PhraseIdProcessed from #Stp1
			
			Create index IX on #PhraseIdProcessed(ID)
			
			Update p
				set isprocessed = 1 
			from [Common].[Phrases] p where exists (select 1 from #PhraseIdProcessed pu where pu.id = p.id)
			
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