@echo off
@title = "Mangos database import tool"
rem Credits to: Factionwars, Nemok, BrainDedd, Antz, sanctum32
:quick
rem Quick install section
rem This will automatically use the variables below to install the world databases without prompting then optimize them and exit
rem To use: Set your environment variables below and change 'set quick=off' to 'set quick=on' 
set quick=off
if %quick% == off goto standard
echo (( Mangos World Database Quick Installer ))
rem -- Change the values below to match your server --
set svr=localhost
set user=mangos
set pass=
set port=3306
set wdb=mangos
rem -- Don't change past this point --
set yesno=y
goto install

:standard
color 1b
rem Standard install section
echo.
echo MM   MM         MM   MM  MMMMM   MMMM   MMMMM
echo MM   MM         MM   MM MMM MMM MM  MM MMM MMM
echo MMM MMM         MMM  MM MMM MMM MM  MM MMM
echo MM M MM         MMMM MM MMM     MM  MM  MMM
echo MM M MM  MMMMM  MM MMMM MMM     MM  MM   MMM
echo MM M MM M   MMM MM  MMM MMMMMMM MM  MM    MMM
echo MM   MM     MMM MM   MM MM  MMM MM  MM     MMM
echo MM   MM MMMMMMM MM   MM MMM MMM MM  MM MMM MMM
echo MM   MM MM  MMM MM   MM  MMMMMM  MMMM   MMMMM
echo         MM  MMM http://getmangos.com
echo         MMMMMM
echo.

echo ==================================================
echo.

set /p svr=MySQL host address?        [localhost]   : 
if %svr%. == . set svr=localhost
set /p port=MySQL port?                [3306]        : 
if %port%. == . set port=3306
set /p user=MySQL username?            [mangos]      : 
if %user%. == . set user=mangos
set /p pass=MySQL password?            [ ]           : 
if %pass%. == . set pass=
set /p wdb=World database name?       [mangos]      : 
if %wdb%. == . set wdb=mangos

:install
set dbpath=full_db
set mysql=dep

:checkpaths
if not exist %dbpath% then goto patherror
if not exist %mysql%\mysql.exe then goto patherror
goto world

:patherror
echo Cannot find required files.
pause
goto :eof

:world
if %quick% == off echo.
if %quick% == off echo This will wipe out your current World database and replace it.
if %quick% == off set /p yesno=Do you wish to continue? (y/n) 

echo.
echo Importing World database
%mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% -e "drop database if exists %wdb%"
%mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% -e "create database if not exists %wdb%"
for %%i in (%dbpath%\*.sql) do echo %%i & %mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% %wdb% < %%i

:done
echo.
echo Done.
echo.
pause