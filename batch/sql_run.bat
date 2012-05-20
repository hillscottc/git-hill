@ECHO off
REM Usage: sql_run.bat {app} {RDxETL/RDxReport}
REM        where {app} in carl, cart, cra, d2, els, gdrs, parts_order  
REM Sample: sql_run.bat carl RDxReport

SET APP=%1
SET DB=%2

SET USER=rdxuserdev
SET PASS=01Music

if %DB%==RDxETL SET BOX=USHPEPVSQL409
if %DB%==RDxReport SET BOX=USHPEPVSQL435

::start sqlcmd -S %BOX%\%BOX% -d %DB% -U %USER% -P %PASS% -i \RDx\ETL\Common\SQL\%APP%.sql -o \RDx\ETL\logs\%APP%\%APP%_sqlcmd_out.txt -W
:: Need rdxuser created on RDxReport. Till then, send no u/p and use global\hills
ECHO on
start sqlcmd -S %BOX%\%BOX% -d %DB% -i \RDx\ETL\Common\SQL\%APP%.sql -o \RDx\ETL\logs\%APP%\%APP%_sqlcmd_out.txt -W