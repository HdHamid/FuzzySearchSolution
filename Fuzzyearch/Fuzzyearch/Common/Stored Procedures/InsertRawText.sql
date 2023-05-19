CREATE PROCEDURE Common.InsertRawText
	@RawText nvarchar(max)
as 

insert into [Test01]..Names([Description])
select s2.[value] from string_split(@RawText,char(10)) s1
	cross apply string_split(s1.[value],'.') s2
where s2.[value] <> char(13) and s2.[value] <> ''


