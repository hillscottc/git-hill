
-- call from cmd with:  runas.exe /netonly /user:GLOBAL\hills  "sqlcmd -S USFSHWSSQL104 -i c:\scripts\sql_test.sql -o c:\scripts\out.txt -W"

--:setvar SQLCMDCOLWIDTH 1000
--:setvar SQLCMDMAXVARTYPEWIDTH 15
--:setvar SQLCMDMAXFIXEDTYPEWIDTH 15




use RDxETL;

select top 5 * from r2.resource;








