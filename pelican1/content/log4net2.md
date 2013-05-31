Title: Using log4net AdoNetAppender
Date: 2013-05-29
Category: Visual Studio
Tags: log4net, sqlserver
Slug: log4net
Author: Scott Hill
Summary: Using log4net AdoNetAppender to write log to SqlServer database table.

# How to store log in database using log4net:

Create a table for Storing log in the SqlServer database

    CREATE TABLE [dbo].[RpLog](
      [Id] [int] IDENTITY(1,1) NOT NULL,
      [Date] [datetime] NOT NULL,
      [Thread] [varchar](255) NOT NULL,
      [Level] [varchar](50) NOT NULL,
      [Logger] [varchar](255) NOT NULL,
      [Method] [varchar](50) NULL,
      [Line] [int] NULL,
      [Message] [varchar](4000) NOT NULL,
      [Exception] [varchar](2000) NULL

Put this web.config/app.config file in configuration tag.

    <!-- Local database. -->
    <!-- CREATE TABLE [dbo].[RpLog](
              [Id] [int] IDENTITY(1,1) NOT NULL,
              [Date] [datetime] NOT NULL,
              [Thread] [varchar](255) NOT NULL,
              [Level] [varchar](50) NOT NULL,
              [Logger] [varchar](255) NOT NULL,
              [Method] [varchar](50) NULL,
              [Line] [int] NULL,
              [Message] [varchar](4000) NOT NULL,
              [Exception] [varchar](2000) NULL    
     -->
    <appender name="ADONetAppender" type="log4net.Appender.AdoNetAppender">
      <bufferSize value="10" />
      <connectionType value="System.Data.SqlClient.SqlConnection, System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" />
      <connectionString value="server=localhost; uid=loguser; pwd=loguser; database=TestingDb" />
      <commandText value="INSERT INTO RpLog ([Date],[Thread],[Level],[Logger],[Method],[Line],[Message],[Exception]) VALUES (@log_date, @thread, @log_level, @logger, @method, @line, @message, @exception)" />
      <filter type="log4net.Filter.LevelRangeFilter">
        <levelMin value="DEBUG"/>
        <levelMax value="FATAL"/>
      </filter>
      <parameter>
        <parameterName value="@log_date"/>
        <dbType value="DateTime"/>
        <layout type="log4net.Layout.RawTimeStampLayout"/>
      </parameter>
      <parameter>
        <parameterName value="@thread"/>
        <dbType value="String"/>
        <size value="255"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%thread"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@log_level"/>
        <dbType value="String"/>
        <size value="50"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%level"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@logger"/>
        <dbType value="String"/>
        <size value="255"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%logger"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@method"/>
        <dbType value="String"/>
        <size value="255"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%method"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@line"/>
        <dbType value="Int32"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%line"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@message"/>
        <dbType value="String"/>
        <size value="4000"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%message"/>
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@exception"/>
        <dbType value="String"/>
        <size value="2000"/>
        <layout type="log4net.Layout.ExceptionLayout"/>
      </parameter>
    </appender>
 
## If you use integrated security then the connection string would be like: 

    <connectionString value=”Data Source=servername;initial Catalog=databasename; Integrated Security=True;”/> 

