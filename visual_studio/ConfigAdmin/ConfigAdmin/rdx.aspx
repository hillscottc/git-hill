<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="rdx.aspx.cs" Inherits="ConfigAdmin.rdx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>RDx</h1>

    <p>Each interface described in <a href="EachInterface.aspx">in just two sentences.</a></p>
 
    <h3>
        ETL Jobs</h3>
    <asp:LinqDataSource ID="lds_jobs" runat="server" ContextTypeName="ConfigAdmin.DataClasses1DataContext"
        EntityTypeName="" OrderBy="name" TableName="Jobs">
    </asp:LinqDataSource>
    <asp:GridView ID="gv_jobs" runat="server" AllowPaging="True" AllowSorting="True"
        PageSize="20" DataSourceID="lds_jobs" AutoGenerateColumns="False" DataKeyNames="id"
        CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" ReadOnly="True"
                SortExpression="id" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="time" HeaderText="time" SortExpression="time" />
            <asp:BoundField DataField="freq" HeaderText="freq" SortExpression="freq" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="cmd" HeaderText="cmd" SortExpression="cmd" />
            <asp:BoundField DataField="result" HeaderText="result" SortExpression="result" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
        </Columns>
        <EditRowStyle BackColor="#999999" />
        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#E9E7E2" />
        <SortedAscendingHeaderStyle BackColor="#506C8C" />
        <SortedDescendingCellStyle BackColor="#FFFDF8" />
        <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
    </asp:GridView>
    <h3>
        Issue Key</h3>
    <asp:LinqDataSource ID="lds_issues" runat="server" ContextTypeName="ConfigAdmin.DataClasses1DataContext"
        EntityTypeName="" OrderBy="id" TableName="IssueViews">
    </asp:LinqDataSource>
    <asp:GridView ID="gv_issues" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="lds_issues" CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" SortExpression="id" InsertVisible="False" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="count" HeaderText="count" SortExpression="count" />
        </Columns>
        <EditRowStyle BackColor="#2461BF" />
        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#EFF3FB" />
        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
        <SortedAscendingCellStyle BackColor="#F5F7FB" />
        <SortedAscendingHeaderStyle BackColor="#6D95E1" />
        <SortedDescendingCellStyle BackColor="#E9EBEF" />
        <SortedDescendingHeaderStyle BackColor="#4870BE" />
    </asp:GridView>

    <h3>LOG FILES</h3>
        <dl>
        <dt>CARL</dt>
        <dd>carl_etl.txt
        </dd>
        </dl>

    <h3>
        BOXES</h3>
    <asp:LinqDataSource ID="lds_boxes" runat="server" ContextTypeName="ConfigAdmin.DataClasses1DataContext"
        EntityTypeName="" OrderBy="env, name" TableName="Boxes" Where='app == "rdx"'>
    </asp:LinqDataSource>
    <asp:GridView ID="GridView3" runat="server" AllowSorting="True" DataSourceID="lds_boxes"
        AutoGenerateColumns="False" DataKeyNames="id" CellPadding="4" ForeColor="#333333"
        GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id"
                ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" SortExpression="app_dirs" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" SortExpression="conn_to" />
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
        RDx (DEV) <span class="box">USHPEWVAPP251</span></p>
    <ul>
        <li><a href="reports/dev_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/dev_rdx_etl_details.txt">App Config Details</a></li>
        <li>NotificationServices</li>
    </ul>
    <p>
        RDx (UAT) <span class="box">USHPEWVAPP204</span></p>
    <ul>
        <li><a href="reports/uat_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/uat_rdx_etl_details.txt">App Config Details</a></li>
        <li>NotificationServices</li>
    </ul>
    <p>
        RDx (PROD) <span class="box">USHPEWVAPP086</span></p>
    <ul>
        <li><a href="reports/prod_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/prod_rdx_etl_details.txt">App Config Details</a></li>
        <li>NotificationServices</li>
    </ul>
</asp:Content>
