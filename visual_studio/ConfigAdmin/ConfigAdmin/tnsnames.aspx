<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="tnsnames.aspx.cs" Inherits="ConfigAdmin.tnsnames" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Oracle Client Installation</h2>
<ol>
<li>Copy client software to \Oracle\InstantClient</li>
<li>Place TNSNAMES.ora file into \Oracle\InstantClient\TNS</li>
<li>System Variable: PATH to include \Oracle\InstantClient</li>
<li>System Variable: TNS_ADMIN to \Oracle\InstantClient\TNS</li>
</ol>

<h2>TNSNAMES.ora</h2>
<pre>

RMSDEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = usushux03)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsdev))
  )

#RMSDEV =
#  (DESCRIPTION =
#    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs021.global.umusic.ext)(PORT = 1521))
#    (CONNECT_DATA = (SID = rmsdev))
#  )

RMSGQLA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsgqla))
  )

GQLA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsgqla))
  )

DEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs021.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsdev))
  )



RMSDSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs021.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsdsnap))
  )

DSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs021.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsdsnap))
  )

QA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs003.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsqa))
  )

RMSQA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs003.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsqa))
  )

UAT =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs005.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsuat))
  )

RMSUAT =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs005.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsuat))
  )

TRAIN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs004.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmstrain))
  )

TRAINING =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs004.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmstrain))
  )

RMSTRAIN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs004.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmstrain))
  )

GPLA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsgpla))
  )

RMSGPLA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsgpla))
  )

PROD =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs007.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsprod))
  )

RMSPROD =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs007.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsprod))
  )

PSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs006.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmspsnap))
  )

RMSPSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs006.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmspsnap))
  )

USNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs008.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsusnap))
  )

RMSUSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs008.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsusnap))
  )

RMSUSNAP.WORLD =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs008.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmsusnap))
  )

TSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs008.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmstsnap))
  )

RMSTSNAP =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs008.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = rmstsnap))
  )

GPNA = 
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = pndgpna))
  )

PNDGPNA = 
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = pndgpna))
  )

CONTRAX =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs004.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = contrax)
    )
  )

CONTEST =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs004.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID = contest)
    )
  )

CTXDEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(Host = ushpeavdbs002.global.umusic.ext)(Port = 1521))
    (CONNECT_DATA = (SID = ctxdev))
  )

APACV8=
  (DESCRIPTION=
    (ADDRESS = (PROTOCOL = TCP)(HOST = ushpeavdbs002.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA=  (SID=apacv8))
  ) 

USUX21P2=
  (DESCRIPTION=
    (ADDRESS=(PROTOCOL = TCP)(HOST = USHPEAVDBS011.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA=(SID=usux21p2))
  ) 

GT_PRD =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST =USHPEAVDBS010.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA =(SID= usux20p1))
  )

GT_UAT =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST =USHPEAVDBS014.global.umusic.ext)(PORT = 1521))
    (CONNECT_DATA = (SID= usux24t4))
  )

</pre>
</asp:Content>
