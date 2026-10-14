@echo off
setlocal enabledelayedexpansion
title HillSync - Upload to GitHub
color 0B

echo ================================================================
echo        🏔️  HillSync — Automated GitHub Repository Uploader
echo ================================================================
echo.

:: 1. Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Git is not detected on your system PATH!
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    echo or use GitHub Desktop: https://desktop.github.com/
    echo.
    pause
    exit /b 1
)

echo [1/5] Checking Git configuration...
git config user.name >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    set /p GIT_NAME="Enter your GitHub Name / Username: "
    set /p GIT_EMAIL="Enter your GitHub Email: "
    git config --global user.name "!GIT_NAME!"
    git config --global user.email "!GIT_EMAIL!"
    echo Configured Git user as: !GIT_NAME! ^<!GIT_EMAIL!^>
) else (
    echo Git user already configured.
)

echo.
echo [2/5] Initializing local repository...
if not exist ".git" (
    git init
    echo Repository initialized.
) else (
    echo Existing local git repository found.
)

echo.
echo [3/5] Staging and committing files...
git add .
git commit -m "Initial commit: HillSync 3D Subsurface Utility & AI Risk Intelligence Platform"
git branch -M main

echo.
echo [4/5] Configuring GitHub remote...
git remote get-url origin >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ----------------------------------------------------------------
    echo  Create a new empty repository on GitHub first if you haven't:
    echo  URL: https://github.com/new
    echo  Repository Name: hillsync
    echo  (Do NOT check "Add README" or ".gitignore" as we already have them)
    echo ----------------------------------------------------------------
    echo.
    set /p REPO_URL="Paste your GitHub Repository URL (e.g. https://github.com/your-username/hillsync.git): "
    if "!REPO_URL!"=="" (
        color 0C
        echo [ERROR] No URL provided. Aborting.
        pause
        exit /b 1
    )
    git remote add origin !REPO_URL!
    echo Remote 'origin' linked to: !REPO_URL!
) else (
    for /f "tokens=*" %%a in ('git remote get-url origin') do set CURRENT_REMOTE=%%a
    echo Current remote origin: !CURRENT_REMOTE!
    set /p CHANGE_REMOTE="Do you want to change this remote URL? (y/N): "
    if /i "!CHANGE_REMOTE!"=="y" (
        set /p NEW_URL="Enter new GitHub Repository URL: "
        git remote set-url origin !NEW_URL!
    )
)

echo.
echo [5/5] Pushing to GitHub (main branch)...
echo.
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    color 0A
    echo.
    echo ================================================================
    echo   🎉 SUCCESS! HillSync has been uploaded to your GitHub!
    echo ================================================================
    echo.
) else (
    color 0E
    echo.
    echo ----------------------------------------------------------------
    echo If this failed due to authentication, you may need to:
    echo 1. Sign in via browser popup (Git Credential Manager)
    echo 2. Or use a Personal Access Token (PAT) as your password.
    echo ----------------------------------------------------------------
)

pause
