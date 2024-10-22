@echo off
setlocal

set "SOURCE_DIR=C:\JnJ-soft\Projects\internal\jnj-backend"
set "DEST_ZIP=%SOURCE_DIR%\jnj-backend_backup.zip"

if exist "%DEST_ZIP%" (
    del "%DEST_ZIP%"
    timeout /t 2 >nul
)

:: 7-Zip 사용 (7-Zip이 설치되어 있어야 합니다)
set "SEVENZIP_PATH=C:\Program Files\7-Zip\7z.exe"

if exist "%SEVENZIP_PATH%" (
    "%SEVENZIP_PATH%" a -tzip "%DEST_ZIP%" "%SOURCE_DIR%\*" -xr!node_modules
) else (
    powershell -Command "& {Add-Type -A 'System.IO.Compression.FileSystem'; $ErrorActionPreference = 'Stop'; try { $zip = [System.IO.Compression.ZipFile]::Open('%DEST_ZIP%', 'Create'); Get-ChildItem -Path '%SOURCE_DIR%' -Recurse | Where-Object { $_.FullName -notmatch '\\node_modules\\' -and $_.FullName -notmatch '\\node_modules$' } | ForEach-Object { if (!$_.PSIsContainer) { $relativePath = $_.FullName.Substring('%SOURCE_DIR%'.Length + 1); [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relativePath, 'Optimal') } } } catch { Write-Host $_.Exception.Message } finally { if ($zip) { $zip.Dispose() } } }"
)

if exist "%DEST_ZIP%" (
    echo Compression completed. The zip file is located at %DEST_ZIP%
) else (
    echo Compression failed. Please check the error messages above.
)

pause