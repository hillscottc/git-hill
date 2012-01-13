REM @echo off

net use L: /delete /yes


net use L: \\usfshwsapp134\d$\ftproot\LocalUser\parts_order\dev\in

xcopy L:\*.* d:\RDx\ETL\PartsOrder\Temp

del L:\*.* /Q

net use L: /delete /yes

EXIT

REM exit %errorlevel%