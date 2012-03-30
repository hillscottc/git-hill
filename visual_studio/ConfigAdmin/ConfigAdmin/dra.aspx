<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="dra.aspx.cs" Inherits="ConfigAdmin.dra" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        DRA</h2>
    <asp:LinqDataSource ID="LinqDataSource1" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EntityTypeName="" TableName="Boxes" Where="app == @app" EnableDelete="True" EnableInsert="True"
        EnableUpdate="True">
        <WhereParameters>
            <asp:Parameter DefaultValue="dra" Name="app" Type="String" />
        </WhereParameters>
    </asp:LinqDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataSourceID="LinqDataSource1">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
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
    </asp:GridView>
</asp:Content>
