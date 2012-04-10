<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Scheduling.aspx.cs" Inherits="ConfigAdmin.Scheduling" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1>
        Job Scheduling</h1>

      
  <h3>Before:</h3>

    <img src="/imgs/before_sched.PNG"  alt="before" 
        style="width: 749px; margin-right: 0px" />

<h3>After:</h3>

    <img src="imgs/after_sched.PNG" alt="after" style="width: 784px" />

    <pre>
    
    CARL
    ET 23:45 daily
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe C@RL
    L 00:30 daily
    TSQL @ RDxReport 
    exec CRL.[ArtistExploitationLoad]
    exec CRL.[AssetExploitationLoad]
    exec CRL.[ExceptionLoad]
    exec CRL.[ExceptionAssetLoad]
    exec CRL.[ExceptionExploitationLoad]
    exec CRL.[ExceptionProductLoad]
    exec CRL.[ExceptionTypeLoad]
    exec CRL.[ExploitationLoad]
    exec CRL.[PreclearedVideoLoad]
    exec CRL.[ProdExploitationLoad]

    CART
    ET 00:30 daily
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe CART
    L 23:45 daily
    TSQL @ RDxReport
    exec CART.AssetLoad

    CPRS
    ET every 10 mins daily
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprse
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprst
    L every 5 mins daily
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprsl

    CRA
    ETL 00:00 daily
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe CRA
    L 01:00 daily
    TSQL @ 
    exec CRA.ArticleContractLoad
    exec CRA.ContractLoad
    exec CRA.ContractTerritoryLinkLoad
    exec CRA.RecordingContractLoad

    CTX
    ET 00:00 M-F
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxe
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxt
    L every 2 hours daily
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxl

    D2
    ETL every 30 mins
    D:\RDx\ETL\D2\UMG.RDx.ETL.FileService.EXE d2e
    D:\RDx\ETL\D2\UMG.RDx.ETL.FileService.EXE d2t
    LOAD is TSQL @ RDxETL 
        DECLARE @i as int
        exec  [D2].[LegalLoad] 100000, @i  OUTPUT

    DRA
    ETL 00:00 M-F
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console drae
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console drat
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console dral

    ELS
    ETL 00:30 daily
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe ELS
    L 23:30 daily
    TSQL @ RDxReport
    exec ELS.ArtistLoad

    GDRS
    ETL 22:15 daily
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe GDRS
    L 22:45 daily
    TSQL @ RDxReport
    exec [GDRS].[ReleaseLoad]

    MP
    ETL every 2 hours daily
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpe
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpt
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpl

    PartsOrder 
    ET 00:00 daily
    D:\RDx\ETL\PartsOrder\po.bat
    D:\RDx\ETL\PartsOrder\UMG.RDx.ETL.FileService.exe PartsOrder
    L 00:30 daily
    TSQL @ RDxReport
    exec PO.ReleaseLoad

    R2
    ET every 2 hours, MON-SAT (not sun)
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2e
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2t
    L every 2 hours daily
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2l

    
    </pre>
</asp:Content>
