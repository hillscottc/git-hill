ECHO off
rem Usage: sqlrun.bat RDxETL "SELECT TOP 5 * FROM dbo.Box;"


SET DB=%1
SET QUERY=%2

SET USER=rdxuserdev
SET PASS=01Music

if %DB%==RDxETL SET BOX=USHPEPVSQL409
if %DB%==RDxReport SET BOX=USHPEPVSQL435


ECHO on

sqlcmd -S %BOX%\%BOX% -d %DB% -U %USER% -P %PASS% -W -Q %QUERY%

