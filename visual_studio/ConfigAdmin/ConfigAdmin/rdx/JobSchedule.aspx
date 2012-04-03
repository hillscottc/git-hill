<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="JobSchedule.aspx.cs" Inherits="ConfigAdmin.rdx.JobSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h2>JOB SCHEDULING IMPLEMENTATION</h2>
        <div>
        <a name="CARL"></a>
            <h3>CARL</h3>
            ET 23:45 daily
            <pre>
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe C@RL
            </pre>
            L 00:30 daily
            <pre>
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
            </pre>
        </div>

        <div>
        <a name="CART"></a>
            <h3>CART</h3>
            ET 00:30 daily
            <pre>
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe CART
            </pre>
            L 23:45 daily
            <pre>
    TSQL @ RDxReport
    exec CART.AssetLoad
            </pre>
        </div>


        <div>
        <a name="CPRS"></a>
            <h3>CPRS</h3>
            ET every 10 mins daily
            <pre>
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprse
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprst
            </pre>
            L every 5 mins daily
            <pre>
    D:\RDx\ETL\CPRS\UMG.RDx.ETL.CPRS.exe console cprsl
            </pre>
        </div>
        <div>
        <a name="CRA"></a>
            <h3>CRA</h3>
            ETL 00:00 daily
            <pre>
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe CRA
            </pre>
            L 01:00 daily
            <pre>
    TSQL @ 
    exec CRA.ArticleContractLoad
    exec CRA.ContractLoad
    exec CRA.ContractTerritoryLinkLoad
    exec CRA.RecordingContractLoad
            </pre>
        </div>
        <div>
        <a name="CTX"></a>
            <h3>CTX</h3>
            ET 00:00 M-F
            <pre>
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxe
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxt
            </pre>
    L every 2 hours daily
            <pre>
    D:\RDx\ETL\CTX\UMG.RDx.ETL.CTX.exe console ctxl
            </pre>
        </div>
        <div>
        <a name="D2"></a>
            <h3>D2</h3>
            ETL every 30 mins
            <pre>
    D:\RDx\ETL\D2\UMG.RDx.ETL.FileService.EXE d2e
    D:\RDx\ETL\D2\UMG.RDx.ETL.FileService.EXE d2t
            </pre>
    LOAD is TSQL @ RDxETL 
            <pre>
    DECLARE @i as int
    exec  [D2].[LegalLoad] 100000, @i  OUTPUT
            </pre>
        </div>
        <div>
        <a name="DRA"></a>
            <h3>DRA</h3>           
            ETL 00:00 M-F
            <pre>
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console drae
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console drat
    D:\RDx\ETL\DRA\UMG.RDx.ETL.DRA.exe console dral
            </pre>
        </div>
        <div>
        <a name="ELS"></a>
            <h3>ELS</h3>      
            ETL 00:30 daily
            <pre>
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe ELS
    L 23:30 daily
    TSQL @ RDxReport
    exec ELS.ArtistLoad
            </pre>
        </div>
        <div>
        <a name="GDRS"></a>
            <h3>GDRS</h3> 
            ETL 22:15 daily
            <pre>
    D:\RDx\ETL\Common\UMG.RDx.ETL.FileService.exe GDRS
            </pre>
            L 22:45 daily
            <pre>
    TSQL @ RDxReport
    exec [GDRS].[ReleaseLoad]
            </pre>
        </div>
        <div>
        <a name="MP"></a>
            <h3> MP</h3>    
            ETL every 2 hours daily
            <pre>
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpe
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpt
    D:\RDx\ETL\MP\UMG.RDx.ETL.MP.exe console mpl
            </pre>
        </div>
        <div>
        <a name="PartsOrder"></a>
            <h3>PartsOrder</h3>
            ET 00:00 daily
            <pre>
    D:\RDx\ETL\PartsOrder\po.bat
    D:\RDx\ETL\PartsOrder\UMG.RDx.ETL.FileService.exe PartsOrder
            </pre>
            L 00:30 daily
            <pre>
    TSQL @ RDxReport
    exec PO.ReleaseLoad
            </pre>
        </div>
        <div>
        <a name="R2"></a>
            <h3>R2</h3>
            ET every 2 hours, MON-SAT (not sun)
            <pre>
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2e
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2t
            </pre>
        L every 2 hours daily
            <pre>
    D:\RDx\ETL\R2\UMG.RDx.ETL.R2.exe console r2l
            </pre>
        </div>
    </div>
</asp:Content>
