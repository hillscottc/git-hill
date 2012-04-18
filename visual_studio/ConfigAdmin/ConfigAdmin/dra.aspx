<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="dra.aspx.cs" Inherits="ConfigAdmin.dra" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        DRA</h2>
    <asp:LinqDataSource ID="lds_dra" runat="server" 
        ContextTypeName="ConfigAdmin.DataClasses2DataContext" EntityTypeName="" 
        OrderBy="env, tulsa"  TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to)"
        Where="app == @app &amp;&amp; type == @type &amp;&amp; active == @active">
        <WhereParameters>
            <asp:Parameter DefaultValue="dra" Name="app" Type="String" />
            <asp:Parameter DefaultValue="app" Name="type" Type="String" />
            <asp:Parameter DefaultValue="1" Name="active" Type="Byte" />
        </WhereParameters>
    </asp:LinqDataSource>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="lds_dra" 
        AutoGenerateColumns="False" AllowSorting="True" 
        CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
            <asp:BoundField DataField="id" HeaderText="id" SortExpression="id"
                ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" 
                    ReadOnly="True" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" 
                    ReadOnly="True" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" 
                    ReadOnly="True" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" 
                    ReadOnly="True" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" 
                    ReadOnly="True" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                    SortExpression="app_dirs" ReadOnly="True" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" SortExpression="conn_to" 
                    ReadOnly="True" />
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


     <asp:LinqDataSource ID="lds_rms" runat="server" ContextTypeName="ConfigAdmin.DataClasses2DataContext"
        EntityTypeName="" OrderBy="env, tulsa" 
        TableName="Boxes" 
        Select="new (id, app, env, tulsa, type, notes, app_dirs, conn_to)"
        Where="app == @app &amp;&amp; type == @type &amp;&amp; active == @active">
        <WhereParameters>
            <asp:Parameter DefaultValue="rmslink" Name="app" Type="String" />
            <asp:Parameter DefaultValue="app" Name="type" Type="String" />
            <asp:Parameter DefaultValue="1" Name="active" Type="Byte" />
        </WhereParameters>
    </asp:LinqDataSource>
    <h2 id="rmslink">
        RMSLink</h2>
    <asp:GridView ID="gv_rms" runat="server" AllowSorting="True"
        DataSourceID="lds_rms" AutoGenerateColumns="False" CellPadding="4" 
        HeaderStyle-HorizontalAlign="Left" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" SortExpression="id"
                ReadOnly="True" />
            <asp:BoundField DataField="app" HeaderText="app" SortExpression="app" 
                ReadOnly="True" />
            <asp:BoundField DataField="env" HeaderText="env" SortExpression="env" 
                ReadOnly="True" />
            <asp:BoundField DataField="tulsa" HeaderText="tulsa" SortExpression="tulsa" 
                ReadOnly="True" />
            <asp:BoundField DataField="type" HeaderText="type" SortExpression="type" 
                ReadOnly="True" />
            <asp:BoundField DataField="notes" HeaderText="notes" SortExpression="notes" 
                ReadOnly="True" />
            <asp:BoundField DataField="app_dirs" HeaderText="app_dirs" 
                SortExpression="app_dirs" ReadOnly="True" />
            <asp:BoundField DataField="conn_to" HeaderText="conn_to" 
                SortExpression="conn_to" ReadOnly="True" />
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
