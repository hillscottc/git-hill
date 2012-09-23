
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 09/23/2012 13:22:06
-- Generated from EDMX file: C:\cygwin\home\shill\git-hill\visual_studio\WebServicesSolution\WebServicesMvcApp1\Models\WebServiceDataModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [WebServicesDb];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'RemoteWebServices'
CREATE TABLE [dbo].[RemoteWebServices] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ServiceName] nvarchar(max)  NOT NULL,
    [ServiceAddress] nvarchar(max)  NOT NULL,
    [Wsdl] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Methods'
CREATE TABLE [dbo].[Methods] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [MethodName] nvarchar(max)  NOT NULL,
    [RemoteWebServiceId] int  NOT NULL
);
GO

-- Creating table 'Params'
CREATE TABLE [dbo].[Params] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Type] nvarchar(max)  NOT NULL,
    [Value] nvarchar(max)  NOT NULL,
    [MethodId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'RemoteWebServices'
ALTER TABLE [dbo].[RemoteWebServices]
ADD CONSTRAINT [PK_RemoteWebServices]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Methods'
ALTER TABLE [dbo].[Methods]
ADD CONSTRAINT [PK_Methods]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Params'
ALTER TABLE [dbo].[Params]
ADD CONSTRAINT [PK_Params]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [RemoteWebServiceId] in table 'Methods'
ALTER TABLE [dbo].[Methods]
ADD CONSTRAINT [FK_RemoteWebServiceMethod]
    FOREIGN KEY ([RemoteWebServiceId])
    REFERENCES [dbo].[RemoteWebServices]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_RemoteWebServiceMethod'
CREATE INDEX [IX_FK_RemoteWebServiceMethod]
ON [dbo].[Methods]
    ([RemoteWebServiceId]);
GO

-- Creating foreign key on [MethodId] in table 'Params'
ALTER TABLE [dbo].[Params]
ADD CONSTRAINT [FK_MethodParam]
    FOREIGN KEY ([MethodId])
    REFERENCES [dbo].[Methods]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_MethodParam'
CREATE INDEX [IX_FK_MethodParam]
ON [dbo].[Params]
    ([MethodId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------