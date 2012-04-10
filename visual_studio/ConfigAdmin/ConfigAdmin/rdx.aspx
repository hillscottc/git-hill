<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="rdx.aspx.cs" Inherits="ConfigAdmin.rdx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>RDx Boxes</h1>

    <h2>
        BOXES</h2>
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


    <br />
    <h3>CPRSNotificationService</h3>
    <ul>
    <li><a href="http://ushpewvapp251/CprsProductUpdate.asmx">http://ushpewvapp251/CprsProductUpdate.asmx</a></li>
    <li><a href="http://ushpewvapp251/admin.asmx">CPRSNotifier Admin, for testing.</a></li>
    <li><a href="http://degutwsapp006/VanillaInterfaceWSV87/VanillaInterface.asmx">CPRS's VanillaInterface</a></li>
    <li>Log at \RDx\ETL\logs\cprs\</li>
    </ul>
    <br />


</asp:Content>
