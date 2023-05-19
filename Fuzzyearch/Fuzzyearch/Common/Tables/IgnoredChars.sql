CREATE TABLE [Common].[IgnoredChars] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Chars]       NVARCHAR (50) NULL,
    [EscapedChar] BIT           NULL,
    [Step]        TINYINT       NULL,
    CONSTRAINT [PK_IgnoredChars] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UnqChars] UNIQUE NONCLUSTERED ([Chars] ASC)
);

