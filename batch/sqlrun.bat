ECHO off
rem Usage: sqlrun.bat ushpepvsql409 "SELECT TOP 5 * FROM dbo.Box;"

SET BOX=%1
SET QUERY=%2

SET USER=rdxuserdev
SET PASS=01Music
SET DB=RDxETL

REM - RDxReport db
IF "%BOX%" == "USHPEPVSQL435" (
	SET USER=ScottH
	SET PASS=H1ll_Sc0!
	SET DB=RDxReport
)

ECHO on

sqlcmd -S %BOX%\%BOX% -d %DB% -U %USER% -P %PASS% -W -Q %QUERY%
