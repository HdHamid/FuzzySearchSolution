CREATE TABLE [Common].[PhraseSourceRelation] (
    [SourceId]  INT NULL,
    [PhrasaeId] INT NOT NULL,
    CONSTRAINT [UnqSourceIdPhrasaeId] UNIQUE NONCLUSTERED ([SourceId] ASC, [PhrasaeId] ASC)
);

