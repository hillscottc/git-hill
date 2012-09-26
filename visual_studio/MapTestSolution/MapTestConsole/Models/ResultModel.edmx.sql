
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 09/25/2012 17:33:25
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

IF OBJECT_ID(N'[dbo].[FK_TestItemVendorTestResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[VendorTestResults] DROP CONSTRAINT [FK_TestItemVendorTestResult];
GO
IF OBJECT_ID(N'[dbo].[FK_VendorVendorTestResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[VendorTestResults] DROP CONSTRAINT [FK_VendorVendorTestResult];
GO
IF OBJECT_ID(N'[dbo].[FK_FirstVendorTestResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[DistanceResults] DROP CONSTRAINT [FK_FirstVendorTestResult];
GO
IF OBJECT_ID(N'[dbo].[FK_SecondVendorTestResult]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[DistanceResults] DROP CONSTRAINT [FK_SecondVendorTestResult];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[TestItems]', 'U') IS NOT NULL
    DROP TABLE [dbo].[TestItems];
GO
IF OBJECT_ID(N'[dbo].[DistanceResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DistanceResults];
GO
IF OBJECT_ID(N'[dbo].[Vendors1]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Vendors1];
GO
IF OBJECT_ID(N'[dbo].[VendorTestResults]', 'U') IS NOT NULL
    DROP TABLE [dbo].[VendorTestResults];
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

-- Creating table 'DistanceResults'
CREATE TABLE [dbo].[DistanceResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Distance] decimal(18,0)  NOT NULL,
    [FirstVendorTestResultId] int  NOT NULL,
    [SecondVendorTestResultId] int  NOT NULL
);
GO

-- Creating table 'Vendors'
CREATE TABLE [dbo].[Vendors] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'VendorTestResults'
CREATE TABLE [dbo].[VendorTestResults] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [TestItemId] int  NOT NULL,
    [VendorId] int  NOT NULL,
    [Longitude] decimal(18,0)  NOT NULL,
    [Latitude] decimal(18,0)  NOT NULL
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

-- Creating primary key on [Id] in table 'DistanceResults'
ALTER TABLE [dbo].[DistanceResults]
ADD CONSTRAINT [PK_DistanceResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Vendors'
ALTER TABLE [dbo].[Vendors]
ADD CONSTRAINT [PK_Vendors]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'VendorTestResults'
ALTER TABLE [dbo].[VendorTestResults]
ADD CONSTRAINT [PK_VendorTestResults]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [TestItemId] in table 'VendorTestResults'
ALTER TABLE [dbo].[VendorTestResults]
ADD CONSTRAINT [FK_TestItemVendorTestResult]
    FOREIGN KEY ([TestItemId])
    REFERENCES [dbo].[TestItems]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_TestItemVendorTestResult'
CREATE INDEX [IX_FK_TestItemVendorTestResult]
ON [dbo].[VendorTestResults]
    ([TestItemId]);
GO

-- Creating foreign key on [VendorId] in table 'VendorTestResults'
ALTER TABLE [dbo].[VendorTestResults]
ADD CONSTRAINT [FK_VendorVendorTestResult]
    FOREIGN KEY ([VendorId])
    REFERENCES [dbo].[Vendors]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_VendorVendorTestResult'
CREATE INDEX [IX_FK_VendorVendorTestResult]
ON [dbo].[VendorTestResults]
    ([VendorId]);
GO

-- Creating foreign key on [FirstVendorTestResultId] in table 'DistanceResults'
ALTER TABLE [dbo].[DistanceResults]
ADD CONSTRAINT [FK_FirstVendorTestResult]
    FOREIGN KEY ([FirstVendorTestResultId])
    REFERENCES [dbo].[VendorTestResults]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_FirstVendorTestResult'
CREATE INDEX [IX_FK_FirstVendorTestResult]
ON [dbo].[DistanceResults]
    ([FirstVendorTestResultId]);
GO

-- Creating foreign key on [SecondVendorTestResultId] in table 'DistanceResults'
ALTER TABLE [dbo].[DistanceResults]
ADD CONSTRAINT [FK_SecondVendorTestResult]
    FOREIGN KEY ([SecondVendorTestResultId])
    REFERENCES [dbo].[VendorTestResults]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_SecondVendorTestResult'
CREATE INDEX [IX_FK_SecondVendorTestResult]
ON [dbo].[DistanceResults]
    ([SecondVendorTestResultId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------