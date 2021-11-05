CREATE TABLE [Fuzzy].[PhraseChars] (
    [PhraseId]  INT     NULL,
    [CharId]    TINYINT NOT NULL,
    [LenString] INT     NULL,
    [CharPlace] INT     NULL,
    [UnqNn]     INT     NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_PhraseChars]
    ON [Fuzzy].[PhraseChars]([PhraseId] ASC, [CharId] ASC, [CharPlace] ASC);

