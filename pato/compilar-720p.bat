@echo off
cd src
echo Compilando...
..\..\bennu-win\bgdc -g -D DEBUG=1 pato.prg
move pato.dcb ..
pause
cd ..
..\bennu-win\bgdi pato.dcb

pause
exit