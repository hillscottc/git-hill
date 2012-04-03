<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ctx.aspx.cs" Inherits="ConfigAdmin.ctx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    
    
    <asp:LinqDataSource ID="lds_ctx" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="env, tulsa"
        TableName="Boxes" Where='app == "ctx"'>
    </asp:LinqDataSource>
    <h2>Contraxx</h2>


    <br />
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="lds_ctx" AutoGenerateColumns="False" >
        <Columns>
            <asp:CommandField ShowEditButton="True" />
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="notes" HeaderText="notes" />
            <asp:TemplateField HeaderText="conn_to">
                <ItemTemplate>
                    <%# SemiColonToBr(Eval("conn_to")) %> 
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="app_dirs">
                <ItemTemplate>
                    <%# SemiColonToBr(Eval("app_dirs"))%> 
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />

    <asp:LinqDataSource ID="lds_citrix" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="env, tulsa"
        TableName="Boxes" Where='app == "citrix"' EntityTypeName="">
    </asp:LinqDataSource>

    <a name="citrix"></a>
    <h2>Citrix</h2>

    <p>
    The Contraxx dev environments are served by Citrix offering simple Remote-Desktop-like access to the app directories.
    The prod environment is a fully Citrix-hosted application.
    </p>

    <br />
    <asp:GridView ID="GridView4" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="lds_citrix" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" />
        </Columns>
    </asp:GridView>

     <br />

    <a name="sentry"></a>
    <h2>Sentry</h2>
    <p>
 Contraxx Sentry performs several functions in a Contraxx environment. It is named Sentry because it watches for operations that need to be done, and performs those it finds. The types of functions that Sentry executes are: 
    </p>
    <ul>
    <li>Normalizing Contraxx data for reporting.</li>
    <li>Sending Contraxx "Notification" email messages.</li>
    <li>Generating and emailing reports on a scheduled basis.</li>
    <li>"Reverse normalizing" data from conversion or interface processes.</li>
    </ul>

    <p>
    Sentry is composed of two pieces:<br />
<i>SentryService.exe</i> is a Windows service application. It launches the main Sentry.exe periodically to actually do the work. 
Use Windows Services Manager to manage execution of the <i>Contraxx Sentry</i> service. 
It is configured with file <i>ctxshare.ini</i>.
    </p>
    Registry:
    <pre>
KEY: HKEY_LOCAL_MACHINE\SOFTWARE\Contraxx
NAME: Sentry Path
VALUE: D:\Contraxx\UATv8Current-rmsdev
     </pre>
    <asp:LinqDataSource ID="lds_sentry" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="env, tulsa"
        TableName="Boxes" Where="app == @app">
        <WhereParameters>
            <asp:Parameter DefaultValue="sentry" Name="app" Type="String" />
        </WhereParameters>
    </asp:LinqDataSource>
    <br />
    <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="lds_sentry" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" SortExpression="conn_to" />
            <asp:BoundField DataField="app_dirs" HeaderText="app dir" SortExpression="app_dirs" />
        </Columns>
    </asp:GridView>
    <br />

    <a name="rmslink"></a>
    <h2>RMSLink</h2>
    <asp:LinqDataSource ID="lds_rmslink" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="env, tulsa"
        TableName="Boxes" Where="app == @app">
        <WhereParameters>
            <asp:Parameter DefaultValue="rmslink" Name="app" Type="String" />
        </WhereParameters>
    </asp:LinqDataSource>
    <br />
    <asp:GridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="lds_rmslink" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" SortExpression="conn_to" />
            <asp:BoundField DataField="app_dirs" HeaderText="app dir" SortExpression="app_dirs" />
        </Columns>
    </asp:GridView>
    <br />

 
</asp:Content>
