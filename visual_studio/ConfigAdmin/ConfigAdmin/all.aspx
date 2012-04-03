<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="all.aspx.cs" Inherits="ConfigAdmin.all" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

   <asp:LinqDataSource ID="lds_all" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="app, env, tulsa"
        TableName="Boxes">
    </asp:LinqDataSource>
    <h2>All</h2>

    <br />
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="lds_all" AutoGenerateColumns="False" PageSize="50">
        <Columns>
            <asp:CommandField ShowEditButton="True" />
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" SortExpression="id" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" />
            <asp:BoundField DataField="fishers" HeaderText="fishers" SortExpression="fishers" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" />
            <asp:BoundField DataField="name" HeaderText="name" />
            <asp:BoundField DataField="notes" HeaderText="notes"  />
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

</asp:Content>
