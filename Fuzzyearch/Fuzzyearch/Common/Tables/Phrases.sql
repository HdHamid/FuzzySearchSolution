CREATE TABLE [Common].[Phrases] (
    [Phrase]      NVARCHAR (250) NOT NULL,
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [IsProcessed] BIT            CONSTRAINT [DF_Phrases_Processed] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Phrases] PRIMARY KEY CLUSTERED ([Phrase] ASC)
);

