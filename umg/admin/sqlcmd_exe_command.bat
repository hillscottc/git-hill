echo off
rem Get a cmd shell with proper credentials first.
rem Start > Run > runas.exe /netonly /user:GLOBAL\hills cmd
echo on
sqlcmd ^
-S USFSHWSSQL089 ^
-d RDxReport ^
-q "SELECT TOP 10 * FROM R2ReleaseLookupDetail" ^
-W ^
-w 150




