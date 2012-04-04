<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="rdx2.aspx.cs" Inherits="ConfigAdmin.rdx.rdx2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<br />
<h3>ETL Jobs</h3>
<%--
<ul id="etl_job_list">
<li><a href="JobSchedule.aspx#carl">CARL</a></li>
<li><a href="JobSchedule.aspx#CART">CART</a></li>
<li><a href="JobSchedule.aspx#CPRS">CPRS</a></li>
<li><a href="JobSchedule.aspx#CRA">CRA</a></li>
<li><a href="JobSchedule.aspx#CTX">CTX</a></li>
<li><a href="JobSchedule.aspx#D2">D2</a></li>
<li><a href="JobSchedule.aspx#DRA">DRA</a></li>
<li><a href="JobSchedule.aspx#ELS">ELS</a></li>
<li><a href="JobSchedule.aspx#GDRS">GDRS</a></li>
<li><a href="JobSchedule.aspx#MP">MP</a></li>
<li><a href="JobSchedule.aspx#PartsOrder">PartsOrder</a></li>
<li><a href="JobSchedule.aspx#R2">R2</a></li>
</ul>--%>
   
     <asp:LinqDataSource ID="lds_jobs" runat="server" 
        ContextTypeName="ConfigAdmin.DataClasses1DataContext" EnableDelete="True" 
        EnableInsert="True" EnableUpdate="True" EntityTypeName="" OrderBy="name" 
        TableName="Jobs">
    </asp:LinqDataSource>

    <asp:GridView ID="GridView2" runat="server" AllowPaging="True" 
        AllowSorting="True" DataSourceID="lds_jobs" PageSize="15">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="False" />
        </Columns>
    </asp:GridView>



    
    <h3>Boxes</h3>
    <asp:LinqDataSource ID="LinqDataSource1" runat="server" ContextTypeName="ConfigAdmin.DataClasses1DataContext"
        OrderBy="env, tulsa" TableName="Boxes" Where="app == @app" 
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" EntityTypeName="">
        <WhereParameters>
            <asp:Parameter DefaultValue="rdx" Name="app" Type="String" />
        </WhereParameters>
    </asp:LinqDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="LinqDataSource1" AutoGenerateColumns="False" 
        DataKeyNames="id">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" 
                SortExpression="id" ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" SortExpression="name"  />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" />
        </Columns>
    </asp:GridView>
    <p>
        <a name="dev">RDx (DEV) <span class="box">USHPEWVAPP251</span></a></p>
    <ul>
        <li><a href="reports/dev_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/dev_rdx_etl_details.txt">App Config Details</a></li>
        <li>RDx Web</li>
        <li>NotificationServices</li>
    </ul>
    <p>
        <a name="uat">RDx (UAT) <span class="box">USHPEWVAPP204</span></a></p>
   
    <ul>
        <li><a href="reports/uat_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/uat_rdx_etl_details.txt">App Config Details</a></li>
        <li>RDx Web</li>
        <li>NotificationServices</li>
   
    </ul>
    <p>
        <a name="prod">RDx (PROD) <span class="box">USHPEWVAPP086</span></a></p>
 
    <ul>
        <li><a href="reports/prod_rdx_etl_summary.txt">App Config Summary</a></li>
        <li><a href="reports/prod_rdx_etl_details.txt">App Config Details</a></li>
        <li>RDx Web</li>
        <li>NotificationServices</li>
    </ul>
</asp:Content>
