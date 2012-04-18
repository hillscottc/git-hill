<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ctx.aspx.cs" Inherits="ConfigAdmin.ctx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <asp:LinqDataSource ID="lds_ctx" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="type, tulsa, env" 
        TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to)" 
        Where="app == @app &amp;&amp; type == @type &amp;&amp; active == @active">
        <WhereParameters>
            <asp:Parameter DefaultValue="ctx" Name="app" Type="String" />
            <asp:Parameter DefaultValue="app" Name="type" Type="String" />
            <asp:Parameter DefaultValue="1" Name="active" Type="Byte" />
        </WhereParameters>
    </asp:LinqDataSource>
    <h2>
        Installed Contraxx Versions</h2>
    <asp:GridView ID="gv_ctx" runat="server" AllowSorting="True" DataSourceID="lds_ctx"
        AutoGenerateColumns="False" CellPadding="4" HeaderStyle-HorizontalAlign="Left"
        GridLines="Horizontal" BackColor="White" BorderColor="#336666" 
        BorderStyle="Double" BorderWidth="3px">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" SortExpression="id"
                ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" 
                ReadOnly="True" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" 
                ReadOnly="True" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" 
                ReadOnly="True" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" 
                ReadOnly="True" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" 
                ReadOnly="True" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" ReadOnly="True" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" ReadOnly="True" />
        </Columns>
        <FooterStyle BackColor="White" ForeColor="#333333" />
        <HeaderStyle BackColor="#336666" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="White" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="#F7F7F7" />
        <SortedAscendingHeaderStyle BackColor="#487575" />
        <SortedDescendingCellStyle BackColor="#E5E5E5" />
        <SortedDescendingHeaderStyle BackColor="#275353" />
    </asp:GridView>
    <p>
        The Contraxx dev environments are served by Citrix offering simple Remote-Desktop-like
        access to the app directories. The prod environment is a fully Citrix-hosted application.
    </p>
    <br />



     <h2 id="citrix">
        Citrix Servers</h2>

    <asp:LinqDataSource ID="lds_citrix" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="env, tulsa"  
        TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to)"
        Where="app == @app &amp;&amp; type == @type &amp;&amp; active == @active">
        <WhereParameters>
            <asp:Parameter DefaultValue="ctx" Name="app" Type="String" />
            <asp:Parameter DefaultValue="citrix" Name="type" Type="String" />
            <asp:Parameter DefaultValue="1" Name="active" Type="Byte" />
        </WhereParameters>
    </asp:LinqDataSource>

    <asp:GridView ID="gv_citrix" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" CellPadding="4" HeaderStyle-HorizontalAlign="Left"
        DataSourceID="lds_citrix" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" 
                ReadOnly="True" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" 
                ReadOnly="True" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" 
                ReadOnly="True" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" 
                SortExpression="tulsa" ReadOnly="True" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" 
                ReadOnly="True" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" 
                ReadOnly="True" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" ReadOnly="True" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" ReadOnly="True" />
        </Columns>
        <EditRowStyle BackColor="#7C6F57" />
        <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#E3EAEB" />
        <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#F8FAFA" />
        <SortedAscendingHeaderStyle BackColor="#246B61" />
        <SortedDescendingCellStyle BackColor="#D4DFE1" />
        <SortedDescendingHeaderStyle BackColor="#15524A" />
    </asp:GridView>


<br />
    <asp:LinqDataSource ID="lds_sentry" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="env, tulsa"   
        TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to)"
        Where="app == @app &amp;&amp; type == @type &amp;&amp; active == @active">
        <WhereParameters>
            <asp:Parameter DefaultValue="sentry" Name="app" Type="String" />
            <asp:Parameter DefaultValue="service" Name="type" Type="String" />
            <asp:Parameter DefaultValue="1" Name="active" Type="Byte" />
        </WhereParameters>
    </asp:LinqDataSource>
    <br />
  
    <h2 id="sentry">
        Sentry</h2>
    <asp:GridView ID="gv_sentry" runat="server" AllowSorting="True"
        DataSourceID="lds_sentry" AutoGenerateColumns="False" HeaderStyle-HorizontalAlign="Left"
        CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" SortExpression="id"
                ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" 
                ReadOnly="True" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" 
                ReadOnly="True" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" 
                ReadOnly="True" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" 
                ReadOnly="True" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" 
                ReadOnly="True" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" ReadOnly="True" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" ReadOnly="True" />
        </Columns>
        <EditRowStyle BackColor="#7C6F57" />
        <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#E3EAEB" />
        <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#F8FAFA" />
        <SortedAscendingHeaderStyle BackColor="#246B61" />
        <SortedDescendingCellStyle BackColor="#D4DFE1" />
        <SortedDescendingHeaderStyle BackColor="#15524A" />
    </asp:GridView>
    <p>
        Contraxx Sentry performs several functions in a Contraxx environment. It is named
        Sentry because it watches for operations that need to be done, and performs those
        it finds. The types of functions that Sentry executes are:
    </p>
    <ul>
        <li>Normalizing Contraxx data for reporting.</li>
        <li>Sending Contraxx "Notification" email messages.</li>
        <li>Generating and emailing reports on a scheduled basis.</li>
        <li>"Reverse normalizing" data from conversion or interface processes.</li>
    </ul>
    <p>
        Sentry is composed of two pieces:<br />
        <i>SentryService.exe</i> is a Windows service application. It launches the main
        Sentry.exe periodically to actually do the work. Use Windows Services Manager to
        manage execution of the <i>Contraxx Sentry</i> service. It is configured with file
        <i>ctxshare.ini</i>.
    </p>
    Registry:
    <pre>
KEY: HKEY_LOCAL_MACHINE\SOFTWARE\Contraxx
NAME: Sentry Path
VALUE: D:\Contraxx\UATv8Current-rmsdev
     </pre>
    <br />
    <br />
   
    <br />
    <br />
</asp:Content>
