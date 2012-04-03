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
            <asp:BoundField DataField="name" HeaderText="name" />
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
</asp:Content>
