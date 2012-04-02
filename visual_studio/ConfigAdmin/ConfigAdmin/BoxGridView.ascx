<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="BoxGridView.ascx.cs" Inherits="ConfigAdmin.BoxGridView" %>


<%-- note AutoEventWireup is false, so i can manage the controls from code behind --%>

<%-- this isnt working yet. --%>



    <asp:LinqDataSource ID="LinqDataSource1" runat="server" ContextTypeName="ConfigAdmin.InfraDataContext"
        EnableDelete="True" EnableInsert="True" EnableUpdate="True" OrderBy="env, tulsa"
        TableName="Boxes" Where='app == "ctx"'>
    </asp:LinqDataSource>
    <h2>Contraxx</h2>

    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        DataSourceID="LinqDataSource1" AutoGenerateColumns="False">
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



