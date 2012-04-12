<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="ConfigAdmin._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <h2>
        <a name="migration">Migration Reports </a>
    </h2>
    <ul>
        <li><a href="http://teams8.sharepoint.hp.com/teams/UMG/Delivery/Apps/Lists/UMG%20Mig%20Status%20RR%20RepRights/AllItems.aspx">
            R & R - Rep & Rights SharePoint Status List</a> </li>
        <li><a href="http://teams8.sharepoint.hp.com/teams/UMG/Transformation/Integrated%20Transformation%20Project%20plans/Forms/AllItems.aspx">
            Migration Workbook</a> </li>
    </ul>
    <p>
        Open issues</p>
    <ul>
        <li>Links to CTX, DRA, and R2 need to be re-created. (Send request to DBA.)</li>
        <li>Permissions for FileService.exe's BULK LOAD from SQLServer to ftp files on app server. (Send request to DBA.)</li>
        <li>Create a service account for running jobs.</li>
        <li>Oracle Client and configured TNS install on any CTX/SENTRY app servers that still need it. </li>
        <li>Concurrency of SQL scripts. Can there be one sql_run.bat to call each app.sql? Or clone sql_run.bat to carl_sql_run.bat, cart_sql_run.bat, etc.</li>
        <li>Verify DATABASE logging. Needed in addition ot text logs for those apps that use it to track last run.</li>
    </ul>

    <hr />
    <div>This site is the 
    <asp:Label id="labEnv" runat="server" Text="Label" Font-Names="Consolas" 
            ForeColor="Black"></asp:Label> configuration, 
    connecting with <asp:Label id="labCon" runat="server" Text="Label" 
            Font-Names="Consolas" ForeColor="Black"></asp:Label>.
    </div>

</asp:Content>
