<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EachInterface.aspx.cs" Inherits="ConfigAdmin.EachInterface" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

   <h2>Each Interface. Two Sentences.</h2>

    <dl>
        <dt>CARL</dt>
        <dd>Receives data via FTP of text file. FileService console app processes file by 
            scheduled execution of custom SQL script, calling a collection of stored procedures. 
        </dd>

        <dt>CART</dt>
        <dd>Receives data via FTP of text file. Processed by scheduled execution of custom SQL script
        , calling a collection of stored procedures. 
        </dd>

        <dt>CPRS</dt>
        <dd>CPRS app sends notifications of changes (ids) to our (CPRS)NotificationService.
        NotificationService writes ids to our db, then a custom console app uses the ids
         to query back to CPRS's VanillaInterface web service for complete data. 
        </dd>

        <dt>CRA</dt>
        <dd>Receives data via FTP of text file. Processed by scheduled execution of custom SQL script, 
        which calls various stored procedures.
        </dd>

        <dt>Contraxx (CTX)</dt>
        <dd>
        Data is queried from the app's Oracle db. Processed by scheduled execution of a custom console app calling 
        a collection of stored procedures.
        </dd>

        <dt>D2</dt>
        <dd>Receives data via FTP of text file. Processed by scheduled execution of custom SQL script, 
        which calls various stored procedures.
        </dd>


        <dt>DRA</dt>
        <dd>Data is queried from the app's Oracle db.  Processed by scheduled execution of a custom console app calling 
        a collection of stored procedures.
        </dd>

        <dt>ELS</dt>
        <dd>Receives data via FTP of text file. Processed by scheduled execution of custom SQL script, 
        which calls various stored procedures.
        </dd>

        <dt>GDRS</dt>
        <dd>Receives data via FTP of text file. Processed by scheduled execution of custom SQL script, 
        which calls various stored procedures.
        </dd>


        <dt>Media Portal</dt>
        <dd>Scheduled execution of a custom console app querys MP's web service for changed records by date.
         Console app calls a collection of stored procedures to process data.
        </dd>

        <dt>PartsOrder</dt>
        <dd>Receives data via FTP of text file. Scheduled execution of a DOS batch file (po.bat) follows,
        then the FTP file is processed.
        </dd>

        <dt>R2</dt>
        <dd>Data is queried from the app's Oracle db.  Processed by scheduled execution of a custom console app calling 
        a collection of stored procedures.
        </dd>


    </dl>



</asp:Content>
