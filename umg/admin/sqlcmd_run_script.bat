@echo off
:: Filename: sqlcmd_run_script.bat
::
:: 1. First get a cmd shell with credentials first.
::    Start > Run > runas.exe /netonly /user:GLOBAL\hills cmd
:: 2. cd %dbscripts%\umg-admin
:: 2. Drop the sql script to run into %dbscripts%\umg-admin\PROD_SCRIPTS (PATH_ROOT)
:: 3. Usage: 
::    > sqlcmd_run_script.bat sql_test.sql USFSHWSSQL094
::
set SCRIPT=%1
set DB=%2

set PATH_ROOT=%dbscripts%\umg-admin\PROD_SCRIPTS

@echo on

sqlcmd -S %DB% ^
-i "%PATH_ROOT%\%SCRIPT%" ^
-o "%PATH_ROOT%\%SCRIPT%.out.txt" ^
-W

