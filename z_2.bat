@echo off
setlocal enabledelayedexpansion

set "SOURCE_DIR="
set "DEST_DIR="
set "EXCLUDE="

:parse
if "%~1"=="" goto :main
if /i "%~1"=="-s" set "SOURCE_DIR=%~2" & shift & shift & goto :parse
if /i "%~1"=="-d" set "DEST_DIR=%~2" & shift & shift & goto :parse
if /i "%~1"=="-e" set "EXCLUDE=%~2" & shift & shift & goto :parse
if /i "%~1"=="-h" goto :help
shift
goto :parse

:help
echo Usage: z.bat -s "source_directory" -d "destination_directory" -e "exclude1,exclude2,..."
echo.
echo Options:
echo   -s : Source directory
echo   -d : Destination directory
echo   -e : Excluding directories (comma-separated)
echo   -h : Show this help message
goto :eof

:main
if "%SOURCE_DIR%"=="" echo Source directory is not specified. Use -s option. & goto :help
if "%DEST_DIR%"=="" echo Destination directory is not specified. Use -d option. & goto :help

set "DEST_ZIP=%DEST_DIR%\jnj-backend_backup.zip"

if exist "%DEST_ZIP%" (
    del "%DEST_ZIP%"
    timeout /t 2 >nul
)

:: 7-Zip 사용 (7-Zip이 설치되어 있어야 합니다)
set "SEVENZIP_PATH=C:\Program Files\7-Zip\7z.exe"

if exist "%SEVENZIP_PATH%" (
    set "EXCLUDE_ARGS="
    for %%i in (%EXCLUDE%) do (
        set "EXCLUDE_ARGS=!EXCLUDE_ARGS! -xr!"%%i""
    )
    "%SEVENZIP_PATH%" a -tzip "%DEST_ZIP%" "%SOURCE_DIR%\*" %EXCLUDE_ARGS%
) else (
    echo 7-Zip is not installed. Please install 7-Zip or use an alternative compression method.
    goto :eof
)

if exist "%DEST_ZIP%" (
    echo Compression completed. The zip file is located at %DEST_ZIP%
) else (
    echo Compression failed. Please check the error messages above.
)

goto :eof
