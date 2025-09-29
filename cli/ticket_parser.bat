@echo off
setlocal enabledelayedexpansion
REM Usage: ticket_parser.bat input_log.txt output.csv
if "%~1"=="" (
  echo Usage: %~nx0 input_log.txt [output.csv]
  exit /b 1
)
set "INPUT=%~1"
set "OUTPUT=%~2"
if "%OUTPUT%"=="" set "OUTPUT=parsed.csv"

if not exist "%INPUT%" (
  echo [ERROR] Input file not found: "%INPUT%"
  exit /b 1
)

echo timestamp,customer_id,error_code,message>"%OUTPUT%"

REM Expected log pattern example:
REM [2025-09-28 12:34:56] CID=12345 ERR=E042 Message=Payment failed for order OR-5823
REM Adjust tokens or patterns below to match your logs.

for /f "usebackq delims=" %%L in ("%INPUT%") do (
  set "line=%%L"
  REM Extract timestamp between [ and ]
  set "timestamp="
  for /f "tokens=2 delims=[]" %%A in ("!line!") do set "timestamp=%%A"

  REM Extract CID and ERR
  set "cid="
  set "err="
  for %%A in (!line!) do (
    echo %%A | findstr /b /c:"CID=" >nul && set "cid=%%A"
    echo %%A | findstr /b /c:"ERR=" >nul && set "err=%%A"
    REM Capture message=... (joined remainder)
  )

  REM Strip prefixes
  if defined cid set "cid=!cid:CID=!"
  if defined err set "err=!err:ERR=!"

  REM Extract Message=... (if present)
  set "msg="
  echo !line! | findstr /c:"Message=" >nul
  if not errorlevel 1 (
    for /f "tokens=1* delims=M" %%M in ("!line!") do (
      REM Split at 'Message=' keeping right part
    )
    for /f "tokens=1* delims==" %%X in ("!line!") do (
      REM This basic approach may split at first '='. Use a more reliable parse:
    )
    REM Fallback: find position of 'Message=' and take substring
    set "tag=Message="
    call :substrAfter "!line!" "!tag!" msg
  )

  if not defined timestamp set "timestamp="
  if not defined cid set "cid="
  if not defined err set "err="
  if not defined msg set "msg="

  REM Escape quotes in message
  set "msg=!msg:"=""!"

  echo !timestamp!,!cid!,!err!,"!msg!">>"%OUTPUT%"
)

echo [OK] Parsed -> "%OUTPUT%"
exit /b 0

:substrAfter
REM Args: %1 = string, %2 = marker, %3 = outVar
setlocal enabledelayedexpansion
set "s=%~1"
set "m=%~2"
set "out="
set "pos="
set "temp=!s:%m%=#SPLIT#!"
for /f "tokens=2 delims=#" %%Z in ("!temp!") do set "out=%%Z"
endlocal & set "%~3=%out%"
goto :eof