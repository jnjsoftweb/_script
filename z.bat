@echo off
setlocal enabledelayedexpansion

:: 현재 작업 디렉토리를 소스 디렉토리로 설정
set "SOURCE_DIR=%CD%"
:: 현재 작업 디렉토리의 부모 디렉토리를 대상 디렉토리로 설정
for %%I in ("%SOURCE_DIR%") do set "DEST_DIR=%%~dpI"
:: 제외할 기본 디렉토리들 설정
set "EXCLUDE=node_modules,.git"

:parse
if "%~1"=="" goto :main
if /i "%~1"=="-s" set "SOURCE_DIR=%~2" & shift & shift & goto :parse
if /i "%~1"=="-d" set "DEST_DIR=%~2" & shift & shift & goto :parse
if /i "%~1"=="-e" set "EXCLUDE=%~2" & shift & shift & goto :parse
if /i "%~1"=="-h" goto :help
shift
goto :parse

:help
echo Usage: z.bat [-s "source_directory"] [-d "destination_directory"] [-e "exclude1,exclude2,..."]
echo.
echo Options:
echo   -s : Source directory (기본값: 현재 디렉토리)
echo   -d : Destination directory (기본값: 부모 디렉토리)
echo   -e : Excluding directories (기본값: node_modules,.git)
echo   -h : Show this help message
goto :eof

:main
:: 소스 디렉토리에서 마지막 폴더명을 추출
for %%i in ("%SOURCE_DIR%") do (
    for %%j in ("%%~fi\.") do set "LAST_FOLDER=%%~nxi"
)

set "DEST_ZIP=%DEST_DIR%%LAST_FOLDER%.zip"

if exist "%DEST_ZIP%" (
    del "%DEST_ZIP%"
    timeout /t 2 >nul
)

:: 7-Zip 사용 (7-Zip이 설치되어 있어야 합니다)
set "SEVENZIP_PATH=C:\Program Files\7-Zip\7z.exe"

if exist "%SEVENZIP_PATH%" (
    set "EXCLUDE_ARGS="
    for %%i in (%EXCLUDE%) do (
        set "EXCLUDE_ARGS=!EXCLUDE_ARGS! -xr^!%%i"
    )
    
    echo Executing command:
    echo "%SEVENZIP_PATH%" a -tzip "%DEST_ZIP%" "%SOURCE_DIR%\*" !EXCLUDE_ARGS!
    
    "%SEVENZIP_PATH%" a -tzip "%DEST_ZIP%" "%SOURCE_DIR%\*" !EXCLUDE_ARGS!
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
