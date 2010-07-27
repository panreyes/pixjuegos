@echo off
ECHO CREANDO FPGS...
rd /s /q fpg
mkdir fpg
mkdir fpg\personajes
cd fpg-sources
..\..\bennu-win\bgdc pxlfpg.prg
..\..\bennu-win\bgdi pxlfpg pixpang
cd personajes
..\..\..\bennu-win\bgdc pxlfpg.prg
for /D %%i in (*) do ..\..\..\bennu-win\bgdi pxlfpg %%i
cd ..\..

echo Compilando...
cd src
..\..\bennu-win\bgdc -g dx.prg
move dx.dcb ..
pause
cd ..
..\bennu-win\bgdi dx.dcb

pause
exit