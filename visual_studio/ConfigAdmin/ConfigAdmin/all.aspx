<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="All.aspx.cs" Inherits="ConfigAdmin.All" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:LinqDataSource ID="lds_boxes" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="env, tulsa"   
        TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to, active)">
    </asp:LinqDataSource>
    <br />
    <asp:GridView ID="gv_boxes" runat="server" AutoGenerateColumns="False" 
        AllowSorting="True" DataSourceID="lds_boxes" 
        CellPadding="4" ForeColor="#333333" GridLines="None" 
        HeaderStyle-HorizontalAlign="Left">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" 
                SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" ReadOnly="True" 
                SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" ReadOnly="True" 
                SortExpression="env" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" ReadOnly="True" 
                SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" ReadOnly="True" 
                SortExpression="type" />
            <asp:BoundField DataField="notes" HeaderText="notes" ReadOnly="True" 
                SortExpression="notes" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" ReadOnly="True" 
                SortExpression="app_dirs" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" ReadOnly="True" 
                SortExpression="conn_to" />
            <asp:BoundField DataField="active" HeaderText="active" ReadOnly="True" 
                SortExpression="active" />
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
</asp:Content>
