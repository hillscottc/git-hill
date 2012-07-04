@echo off
for %%x in (USHPEWVAPP103 USHPEWVAPP251 USHPEWVAPP354 USHPEWVAPP085 USHPEWVAPP086 USHPEWVAPP091 USHPEWVAPP061 USHPEWVAPP023 USHPEWVAPP355 USHPEWVAPP204) do (
echo ********Checking %%x *********
net use x: /delete /y
net use x: \\%%x\d$ /user:global\hills PASSW
echo trying  x:\Oracle\InstantClient\TNS\tnsnames.ora
type x:\Oracle\InstantClient\TNS\tnsnames.ora
echo
echo
)
