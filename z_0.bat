@echo off
setlocal

set "SOURCE_DIR=C:\JnJ-soft\Projects\internal\jnj-backend"
set "DEST_ZIP=%SOURCE_DIR%\jnj-backend_backup.zip"

if exist "%DEST_ZIP%" del "%DEST_ZIP%"

powershell -Command "& {Add-Type -A 'System.IO.Compression.FileSystem'; $zip = [System.IO.Compression.ZipFile]::Open('%DEST_ZIP%', 'Create'); Get-ChildItem -Path '%SOURCE_DIR%' -Recurse | Where-Object { $_.FullName -notmatch '\\node_modules\\' -and $_.FullName -notmatch '\\node_modules$' } | ForEach-Object { if (!$_.PSIsContainer) { $relativePath = $_.FullName.Substring('%SOURCE_DIR%'.Length + 1); [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relativePath, 'Optimal') } }; $zip.Dispose() }"

echo Compression completed. The zip file is located at %DEST_ZIP%
pause