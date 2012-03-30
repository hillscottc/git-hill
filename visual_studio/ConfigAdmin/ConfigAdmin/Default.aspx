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
        <li>id 6, access to central ftp</li>
        <li>id 303, tnsnames install/config</li>
        <li>id 305, R2 prod data</li>
        <li>id 21, Citrix servers</li>
    </ul>
</asp:Content>
