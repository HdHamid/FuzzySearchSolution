--exec Fuzzy.Search  @SearchPhrase = N'شیبا'
CREATE procedure [Fuzzy].[Search] 
@SearchPhrase nvarchar(250) 
,@CharLeft int = 0
,@CharRight int = 0
,@Prcnt decimal(5,2) = 60
as 
Drop table if exists #Res2
;with stp1 as 
(
	select @SearchPhrase as Name,len(@SearchPhrase)Ln,substring(@SearchPhrase,1,1) as Chr,1 as CharPlace 
	union all 
	select @SearchPhrase,s.Ln - 1,substring(@SearchPhrase,1+s.CharPlace,1) as Strng,1+s.CharPlace as Position
	from stp1 s 
	where s.Ln-1 > 0 
),stp2 as 
(
	select e.ID as CharId,Name,len(name) as LenString,CharPlace,Chr from stp1 s inner join [Common].[Alphabet] e on e.Chars = s.Chr
)
, stp3 as 
(
	select *,cast(cast(CharId as varchar(50))+cast(CharPlace as varchar(50)) as int) as UnqNn from stp2
) 
select * into #res2 from stp3 



drop table if exists #stp1
;with stp1 as 
(
	select r.*,r2.LenString as SrchStringLen
	from #res2 r2 
	inner join [Fuzzy].[PhraseChars] r on r.CharId = r2.CharId and r.CharPlace between r2.CharPlace - @CharLeft and r2.CharPlace + @CharRight  --r.UnqNn = r2.UnqNn	
)
select * into #stp1 from stp1

drop table if exists #stp2
select s.phraseid,s.LenString,s.SrchStringLen,Count(1) as Cnt into #stp2
from #stp1 s
group by  s.phraseid,s.LenString,s.SrchStringLen
having Count(1)*100.00/(iif(LenString>SrchStringLen,LenString,SrchStringLen)*1.00) >= @Prcnt


select  p.Phrase,s.*,
		ps.SourceId
from #stp2 s 
	inner join [Common].[Phrases] p on p.ID = s.PhraseId
	inner join [Common].[PhraseSourceRelation] ps on ps.PhrasaeId = p.ID
--group by ps.SourceId

