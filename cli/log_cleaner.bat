@echo off
setlocal
REM Usage: log_cleaner.bat input_log.txt output_log.txt
if "%~1"=="" (
  echo Usage: %~nx0 input_log.txt [output_log.txt]
  exit /b 1
)
set "INPUT=%~1"
set "OUTPUT=%~2"
if "%OUTPUT%"=="" set "OUTPUT=cleaned_log.txt"

if not exist "%INPUT%" (
  echo [ERROR] Input file not found: "%INPUT%"
  exit /b 1
)

REM Remove DEBUG/TRACE lines, empty lines, and duplicates
set "TMP=%TEMP%\clean_%RANDOM%.txt"
type "%INPUT%" | findstr /v /r /c:"^$" /c:"DEBUG" /c:"TRACE" > "%TMP%"

REM Deduplicate while preserving order
set "SEEN=%TEMP%\seen_%RANDOM%.txt"
type nul > "%OUTPUT%"
type nul > "%SEEN%"

for /f "usebackq delims=" %%L in ("%TMP%") do (
  findstr /x /c:"%%L" "%SEEN%" >nul || (
    echo %%L>>"%OUTPUT%"
    echo %%L>>"%SEEN%"
  )
)

del "%TMP%" "%SEEN%" >nul 2>&1
echo [OK] Cleaned -> "%OUTPUT%"
endlocal