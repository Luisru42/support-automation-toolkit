@echo off
setlocal enabledelayedexpansion
REM Usage:
REM email_template_gen.bat refund --lang es --name "Carlos R." --order "OR-5823" --ticket "TCK-1009" --out output\refund_es.md
if "%~1"=="" (
  echo Usage: %~nx0 <refund|apology|escalation> --lang <en|es> [--name "Full Name"] [--order "OrderID"] [--ticket "TicketID"] [--out path.md]
  exit /b 1
)

set "TYPE=%~1"
shift

set "LANG="
set "NAME=Customer"
set "ORDER="
set "TICKET="
set "OUT="

:parse
if "%~1"=="" goto build
if /i "%~1"=="--lang" (set "LANG=%~2" & shift & shift & goto parse)
if /i "%~1"=="--name" (set "NAME=%~2" & shift & shift & goto parse)
if /i "%~1"=="--order" (set "ORDER=%~2" & shift & shift & goto parse)
if /i "%~1"=="--ticket" (set "TICKET=%~2" & shift & shift & goto parse)
if /i "%~1"=="--out" (set "OUT=%~2" & shift & shift & goto parse)
echo [ERROR] Unknown option: %~1
exit /b 1

:build
if "%LANG%"=="" set "LANG=en"
if "%OUT%"=="" set "OUT=%TYPE%_%LANG%.md"

set "TPLDIR=%~dp0..\templates"
if /i "%LANG%"=="en" (
  set "TPL=%TPLDIR%\english\%TYPE%.md"
) else (
  set "TPL=%TPLDIR%\spanish\%TYPE%.md"
)

if not exist "%TPL%" (
  echo [ERROR] Template not found: "%TPL%"
  exit /b 1
)

REM Read template and replace placeholders: {{name}}, {{order}}, {{ticket}}, {{date}}
for /f "usebackq delims=" %%L in ("%TPL%") do (
  set "line=%%L"
  set "line=!line:{{name}}=%NAME%!"
  set "line=!line:{{order}}=%ORDER%!"
  set "line=!line:{{ticket}}=%TICKET%!"
  for /f "tokens=1-3 delims=/ " %%D in ("%date%") do set "TODAY=%date%"
  set "line=!line:{{date}}=%TODAY%!"
  echo !line!>>"%OUT%"
)

echo [OK] Generated -> "%OUT%"
endlocal