@echo off
set "_dat=%~1"
if "%_dat%"=="" echo DRAG AND DROP DATAFILE TO THIS SCRIPT&pause&exit

set "_output=%~n1"
cd /d "%~dp0"

title "%_output%"
findstr /l "<game <description> <year> <manufacturer>" "%_dat%" >temp.txt

set "_opt="
findstr /l "<header>" "%_dat%" >nul && set "_opt=skip=1"

(echo game,description,year,manufacturer)>"%_output%.csv"
set /a _count=0
for /f "%_opt% delims=" %%g in (temp.txt) do (
	call :get_str "%%g"

)

del temp.txt
pause&exit

:get_str

set /a _count+=1

if %_count% equ 1 (
	for /f tokens^=2^ delims^=^" %%g in ("%~1") do set "_game=%%g"
	exit /b
)
if %_count% equ 2 (
	for /f "tokens=3 delims=<>" %%g in ("%~1") do set "_desc=%%g"
	exit /b
)
if %_count% equ 3 (
	for /f "tokens=3 delims=<>" %%g in ("%~1") do set "_year=%%g"
	exit /b
)
for /f "tokens=3 delims=<>" %%g in ("%~1") do set "_manu=%%g"
set /a _count=0

if "%_game%"=="yes" set "_game=BIOS"
if "%_game%"=="no" set "_game=BIOS"
	
(echo %_game%,"%_desc%",%_year%,"%_manu%") >>"%_output%.csv"

exit /b