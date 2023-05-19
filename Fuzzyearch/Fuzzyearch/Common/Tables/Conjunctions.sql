CREATE TABLE [Common].[Conjunctions] (
    [Id]    INT           IDENTITY (1, 1) NOT NULL,
    [Words] NVARCHAR (50) NULL,
    CONSTRAINT [PK_Conjunctions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UnqWords] UNIQUE NONCLUSTERED ([Words] ASC)
);

