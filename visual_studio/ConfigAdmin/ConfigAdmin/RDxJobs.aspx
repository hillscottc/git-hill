<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RDxJobs.aspx.cs" Inherits="ConfigAdmin.RDxJobs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1>
        RDx Interfaces</h1>

   <p>Each interface, <a href="EachInterface.aspx">described in just two sentences.</a></p>
 

     <h2>
        ETL Jobs</h2>
    <asp:LinqDataSource ID="lds_jobs" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="name" TableName="Jobs">
    </asp:LinqDataSource>
    <asp:GridView ID="gv_jobs" runat="server" AllowPaging="True" AllowSorting="True"
        PageSize="20" DataSourceID="lds_jobs" AutoGenerateColumns="False" DataKeyNames="id"
        CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
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
    <h3>
        Result Key</h3>
    <asp:LinqDataSource ID="lds_issues" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
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


    <br />


    <h2>Configuration</h2>
    <p>
      Configuration of the various data sources, logging, and messaging are all configured through .config text files.
      Independently, for each interface. There are over two dozen config files requiring changes in over 100 places.
    </p>
    <p>
    To manage all the configurations at once, there is the Python module written for this purpose called ConfigMgr,
    located at D:\pydbutil. For a specified path, it recursively searches for config files and parses out the relevant data for reporting
    or modification.
    </p>

    <pre>
    Usage:
      ipy main.py -p {path} [-w]
    Args: 
      -h: help
      -p: path to config files to be changed
      -w: write. Copies the files from targ dir to work dir and modifies them. 
          (Otherwise, it just reports on files in targ path.)
    Examples:
      D:\pydbutil> ipy main.py -p D:\RDx\ETL
      D:\pydbutil> ipy main.py -p D:\RDx\ETL -w
    </pre>

    <p>Here is ConfigMgr output by environment:</p>
    <ul>
        <li>DEV on <span class="box">USHPEWVAPP251</span> - 
        <a href="reports/dev_rdx_etl_summary.txt">Summary</a> - 
        <a href="reports/dev_rdx_etl_details.txt">Details</a>
        </li>
        <li> UAT on <span class="box">USHPEWVAPP204</span> - 
        <a href="reports/uat_rdx_etl_summary.txt">Summary</a> -
        <a href="reports/uat_rdx_etl_details.txt">Details</a>
        </li>
         <li> PROD on <span class="box">USHPEWVAPP086 (Needs re-configuring.)</span> - 
        <a href="reports/prod_rdx_etl_summary.txt">Summary</a> -
        <a href="reports/prod_rdx_etl_details.txt">Details</a>
        </li>
    </ul>
  <br />



 
</asp:Content>
