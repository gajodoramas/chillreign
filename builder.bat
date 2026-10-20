@echo off
setlocal

set "VERSION=%~1"
if not defined VERSION (
	echo [ERROR] Provide a version number, for example: builder.bat 1.0
	exit /b 1
)

set "ROOT=%~dp0"
set "BUILD_DIR=%ROOT%build"
set "ME3_FILE=%ROOT%nightreign-chillreign.me3"
set "SRC_DIR=%ROOT%src"
set "PARAM_DIR=%ROOT%param"
set "MAIN_ZIP=%BUILD_DIR%\Chillreign v%VERSION%.zip"
set "CSV_ZIP=%BUILD_DIR%\Chillreign v%VERSION% (CSV).zip"

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if errorlevel 1 (
	echo [ERROR] Could not create the build folder.
	exit /b 1
)

echo [1/2] Creating Chillreign v%VERSION%.zip...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Add-Type -AssemblyName System.IO.Compression; Add-Type -AssemblyName System.IO.Compression.FileSystem; $files=@(& git -C $env:ROOT ls-files --cached --others --exclude-standard -- src); if ($LASTEXITCODE -ne 0) { exit 1 }; $archive=[System.IO.Compression.ZipFile]::Open($env:MAIN_ZIP,[System.IO.Compression.ZipArchiveMode]::Create); try { [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,$env:ME3_FILE,[System.IO.Path]::GetFileName($env:ME3_FILE)) | Out-Null; foreach ($file in $files) { $path=Join-Path $env:ROOT $file; [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,$path,$file.Replace('\','/')) | Out-Null } } finally { $archive.Dispose() }"
if errorlevel 1 (
	echo [ERROR] Could not create Chillreign v%VERSION%.zip.
	exit /b 1
)

echo [2/2] Creating Chillreign v%VERSION% (CSV).zip...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path $env:PARAM_DIR\* -DestinationPath $env:CSV_ZIP -Force"
if errorlevel 1 (
	echo [ERROR] Could not create Chillreign v%VERSION% (CSV).zip.
	exit /b 1
)

echo [SUCCESS] Both archives were created in "%BUILD_DIR%".
exit /b 0
