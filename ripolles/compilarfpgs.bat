@echo off
set bits=%1
if "%bits%"==""; set bits=32
ECHO CREANDO FPGS...
cd fpg-sources
copy /y ..\..\utils\pxlfpg.dcb .
..\..\bennu-win\bgdi pxlfpg %bits% cutscenes enemigo1 enemigo2 enemigo3 enemigo4 enemigo5 general jefe1 jefe2 jefe3 jefe4 menu nivel1 nivel2 nivel3 nivel4 nivel5 nivel_survival1 nivel_battleroyale1 nivel_matajefes1 objetos ripolles1 ripolles2 ripolles3 ripolles4 pato
del /f pxlfpg.dcb

cd ..\fpg
ren *.fpg *.fpg.gz
..\..\utils\gzip -d *.fpg.gz
cd ..