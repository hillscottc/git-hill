REM *** /EXCLUDE points to a text file listing the exclusions. 

cd C:\devroot\WebApplication1\WebApplication1
xcopy /I /S /Y *.* z:\WebApplication1 /EXCLUDE:excluded.txt
