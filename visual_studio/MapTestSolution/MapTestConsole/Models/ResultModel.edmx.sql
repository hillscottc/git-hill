
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 09/25/2012 11:10:09
-- Generated from EDMX file: C:\cygwin\home\shill\git-hill\visual_studio\MapTestSolution\MapTestConsole\Models\ResultModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [MapTestResultDb];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_TestItemGoogleResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[GoogleResults] DROP CONSTRAINT [FK_TestItemGoogleResult];
GO
IF OBJECT_ID(N'[dbo].[FK_TestItemOpenStreetResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[OpenStreetResults] DROP CONSTRAINT [FK_TestItemOpenStreetResult];
GO
IF OBJECT_ID(N'[dbo].[FK_TestItemBingResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[BingResults] DROP CONSTRAINT [FK_TestItemBingResult];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[TestItems]', 'U') IS NOT NULL
    DROP TABLE [dbo].[TestItems];
GO
IF OBJECT_ID(N'[dbo].[GoogleResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[GoogleResults];
GO
IF OBJECT_ID(N'[dbo].[OpenStreetResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[OpenStreetResults];
GO
IF OBJECT_ID(N'[dbo].[BingResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[BingResults];
GO
IF OBJECT_ID(N'[dbo].[TestResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[TestResults];
GO
IF OBJECT_ID(N'[dbo].[Vendors]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Vendors];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'TestItems'
CREATE TABLE [dbo].[TestItems] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Address] nvarchar(max)  NOT NULL,
    [CampaignId] int  NOT NULL,
    [ResellerId] int  NOT NULL
);
GO

-- Creating table 'GoogleResults'
CREATE TABLE [dbo].[GoogleResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Longitude] nvarchar(max)  NOT NULL,
    [Latitude] nvarchar(max)  NOT NULL,
    [TestItem_Id] int  NOT NULL
);
GO

-- Creating table 'OpenStreetResults'
CREATE TABLE [dbo].[OpenStreetResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Longitude] nvarchar(max)  NOT NULL,
    [Latitude] nvarchar(max)  NOT NULL,
    [TestItem_Id] int  NOT NULL
);
GO

-- Creating table 'BingResults'
CREATE TABLE [dbo].[BingResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Longitude] nvarchar(max)  NOT NULL,
    [Latitude] nvarchar(max)  NOT NULL,
    [TestItem_Id] int  NOT NULL
);
GO

-- Creating table 'TestResults'
CREATE TABLE [dbo].[TestResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Distance] decimal(18,0)  NOT NULL
);
GO

-- Creating table 'Vendors'
CREATE TABLE [dbo].[Vendors] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'TestItems'
ALTER TABLE [dbo].[TestItems]
ADD CONSTRAINT [PK_TestItems]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'GoogleResults'
ALTER TABLE [dbo].[GoogleResults]
ADD CONSTRAINT [PK_GoogleResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'OpenStreetResults'
ALTER TABLE [dbo].[OpenStreetResults]
ADD CONSTRAINT [PK_OpenStreetResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'BingResults'
ALTER TABLE [dbo].[BingResults]
ADD CONSTRAINT [PK_BingResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'TestResults'
ALTER TABLE [dbo].[TestResults]
ADD CONSTRAINT [PK_TestResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Vendors'
ALTER TABLE [dbo].[Vendors]
ADD CONSTRAINT [PK_Vendors]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [TestItem_Id] in table 'GoogleResults'
ALTER TABLE [dbo].[GoogleResults]
ADD CONSTRAINT [FK_TestItemGoogleResult]
    FOREIGN KEY ([TestItem_Id])
    REFERENCES [dbo].[TestItems]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_TestItemGoogleResult'
CREATE INDEX [IX_FK_TestItemGoogleResult]
ON [dbo].[GoogleResults]
    ([TestItem_Id]);
GO

-- Creating foreign key on [TestItem_Id] in table 'OpenStreetResults'
ALTER TABLE [dbo].[OpenStreetResults]
ADD CONSTRAINT [FK_TestItemOpenStreetResult]
    FOREIGN KEY ([TestItem_Id])
    REFERENCES [dbo].[TestItems]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_TestItemOpenStreetResult'
CREATE INDEX [IX_FK_TestItemOpenStreetResult]
ON [dbo].[OpenStreetResults]
    ([TestItem_Id]);
GO

-- Creating foreign key on [TestItem_Id] in table 'BingResults'
ALTER TABLE [dbo].[BingResults]
ADD CONSTRAINT [FK_TestItemBingResult]
    FOREIGN KEY ([TestItem_Id])
    REFERENCES [dbo].[TestItems]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_TestItemBingResult'
CREATE INDEX [IX_FK_TestItemBingResult]
ON [dbo].[BingResults]
    ([TestItem_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------