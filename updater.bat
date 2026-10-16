@echo off
cd /d "%~dp0"

title Chillreign Updater

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed or not in PATH. This updater needs Git to function correctly.
    goto :error
)
if not exist ".git" (
    echo [ERROR] This folder is not a Git repository.
    goto :error
)

echo [1/2] Fetching latest changes...
git fetch
if errorlevel 1 (
    echo [ERROR] Failed to fetch updates.
    goto :error
)

echo [2/2] Updating to the latest remote status...
rem To avoid possible conflicts we reset the local repository instead of pulling changes.
git reset --hard origin/main >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to reset the repository.
    goto :error
)

echo [SUCCESS] Update completed successfully! Chillreign is now up to date.
goto :end

:error
echo Update failed.

:end
pause
exit /b 0
