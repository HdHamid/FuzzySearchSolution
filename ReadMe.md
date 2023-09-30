# Fuzzy Set-Based Search in SQL Server

Introduction:
Typically, for implementing fuzzy searches, NoSQL databases like Apache Lucene are used. However, implementing fuzzy searches within the SQL Server environment 
introduces Full-Text Search (FTS), which has limited capabilities, especially for the Persian language. Online solutions for this issue that do not involve implementing functions are often slow. 
In this project, I have implemented fuzzy search in SQL Server using highly suitable features in a set-based manner, theoretically promising excellent performance. This approach utilizes tables, 
joins, and proper indexing. You can view the project's output in the form of an RDL report. 

![FuzzySearch](https://github.com/HdHamid/FuzzySearchSolution/blob/master/FuzzySearch.jpg)

## The project includes the following tables:

1- [Common].[Alphabet]: This table contains Persian and English alphabet characters.

2- [Common].[Conjunctions]: This table includes prepositions and verbs that should not be considered during the search. Note: This table should be continuously updated in the project.

3- [Common].[IgnoredChars]: This table contains characters and symbols that should be ignored during the search.

4- [Common].[Phrases]: This table contains phrases extracted from texts registered in the system during preprocessing, which will be used in the search.

5- [Common].[PhraseSourceRelation]: This table links the phrase ID from [Common].[Phrases] to the ID of another operational database table whose record ID is included in this table. Note: If there are multiple tables and sources for this purpose, a column for determining them should also be considered.

6- [Fuzzy].[PhraseChars]: In this table, we see the relationship between [Common].[Alphabet] and [Common].[Phrases], along with the length of the phrase, the character's position in that phrase, and a column named UnqNn for storing the concatenated values of the CharId and CharPlace columns.

## Project Procedures:

1- [Common].[EradicateExtraSpaces]: This procedure is used to remove extra spaces from the text that you intend to register in the system. It is utilized by the [Common].[InsertPhrase] procedure and includes three parameters: the target table name ('DatabaseName.SchemaName.TableName'), the name of the text column for indexing and searching, and the name of the column for table ID.

2- [Common].[InsertPhrase]: This procedure is used to extract phrases from the text column of the target table, cleanse and preprocess the data, and insert it into the phrases table. This procedure also includes the same parameters as mentioned in the procedure above.

3- [Fuzzy].[InsertPhraseChars]: Inserts characters related to textual phrases and identifies their positions in the phrase, then inserts them into the [Fuzzy].[PhraseChars] table.

4- [Fuzzy].[Search]: This procedure is used for fuzzy searching with parameters such as @SearchPhrase (the search phrase), @CharLeft and @CharRight (to allow for character displacement, either 1 or multiple characters to the left and right, for covering typographical errors), and @Prcnt (the percentage of similarity with existing data).

In summary, this project implements a highly efficient fuzzy search in SQL Server using a set-based approach, which should theoretically offer excellent performance. It involves various tables and procedures for preprocessing and searching textual data.
