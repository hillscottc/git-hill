Title: log4net
Date: 2013-05-29
Category: Visual Studio
Tags: log4net
Slug: log4net
Author: Scott Hill
Summary: log4net configuration.



## Field Formatting
Format modifier   lft-just  min    max   comment               
%20logger         false     20     none  Left pad with spaces if less than 20 characters long.                           
%-20logger        true      20     none  Right pad with spaces if less than 20 characters long.                          
%.30logger        NA        none   30    Truncate if longer than 30 characters.                           
%20.30logger      false     20     30    Left pad if less than 20. If longer than 30, trunc.                             
%-20.30logger     true      20     30    Right pad if shorter than 20 chars. If longer than 30, trunc.    


The sequence that represents a CR LF is &#13; &#10;. The following example adds a header and footer to the output each followed by a newline.

    <layout type="log4net.Layout.PatternLayout">
        <header value="[Header]&#13;&#10;" />
        <footer value="[Footer]&#13;&#10;" />
        <conversionPattern value="%date [%thread] %-5level %logger - %message%newline" />


Other format expressions:
expression  value
%appdomain  the friendly name of the appdomain from which the log entry was made
%date   the local datetime when the log entry was made
%exception  a formatted form of the exception object in the log entry, if the entry contains an exception; otherwise, this format expression adds nothing to the log entry
%file   the file name from which the log entry was made; note that using %file has a significant performance impact and I don't recommend using it
%identity   the user name of the active user logging the entry; this one is less reliable than %username; note that using %identity has a significant performance impact and I don't recommend using it
%level  the severity level of the log entry (DEBUG,INFO, etc)
%line   the source code line number from which the log entry was made; slow
%location   some rudimentary call stack information, including file name and line number at which the log entry was made; using
%logger     the name of the logger making the entry; more on this in a bit
%method     the name of the method in which the log entry was made; also slow
%message    the log message itself (don't forget this part!)
%newline    the value of Environment.NewLine
%timestamp  the milliseconds between the start of the application and the time the log entry was made
%type   the full typename of the object from which the log entry was made
%username   the Windows identity of user making the log entry; slow
%utcdate    the UTC datetime when the log entry was made
%%  a percent sign (%)


## Declare in class
    private static readonly log4net.ILog log =  
        log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);



## How do I configure log4net so that log.IsDebugEnabled is true?    
for ASP project..in global.asax, use:

    <%@ Import Namespace="log4net" %>
    <script runat="server">
        void Application_Start(object sender, EventArgs e) 
        {
            Bootstrapper.Configure();
        }
    }

## If you are calling Configure in a class library, adding an attribute to your class's Assembly:
    using log4net.Config;
    [assembly: XmlConfigurator(Watch = true)]


## If you are using a separate configuration file for log4net
After following all the other setup instructions, make sure that u right click on the file in the visual studio solution explorer, select properties, expand the "Advanced" option group, set "Copy To Output Directory" value to "Copy always".


## How to remove warning: The ‘log4net’ element is not declared
- Download the log4net XML Schema Definition (XSD) from http://csharptest.net/downloads/schema/log4net.xsd
- Put the XSD to your project somewhere.
- With the XML file open, in the top menu Select XML -> Schemas
- Locate your log4net.xsd, select 'Use this schema'

## What is the fastest way of (not) logging?
For some logger log, writing:

    log.Debug("Entry number: " + i + " is " + entry[i]);

...incurs the cost of constructing the message parameter, that is converting both integer i and entry[i] to a string, and concatenating intermediate strings, *regardless* of whether the message will be logged or not. If you are worried about speed, then write:  

    if(log.IsDebugEnabled) 
    {
        log.Debug("Entry number: " + i + " is " + entry[i]);
    }






