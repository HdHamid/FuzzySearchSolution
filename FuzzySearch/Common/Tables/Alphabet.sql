CREATE TABLE [Common].[Alphabet] (
    [ID]       TINYINT      IDENTITY (1, 1) NOT NULL,
    [Language] VARCHAR (2)  NOT NULL,
    [Chars]    NVARCHAR (1) NOT NULL,
    CONSTRAINT [PK_Alphabet] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Char]
    ON [Common].[Alphabet]([Chars] ASC);

