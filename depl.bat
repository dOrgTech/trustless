@ECHO OFF
SETLOCAL

REM Check for commit message argument
IF "%~1"=="" (
    ECHO No commit message provided, using default.
    SET "COMMIT_MSG=end of day auto-commit"
) ELSE (
    SET "COMMIT_MSG=%~1"
)

REM Perform git operations
CALL :git_ops "%COMMIT_MSG%"
IF ERRORLEVEL 1 (
    ECHO Git operations failed.
    EXIT /B 1
)

REM Perform flutter and firebase operations
CALL :flutter_firebase_ops
IF ERRORLEVEL 1 (
    ECHO Flutter and Firebase operations failed.
    EXIT /B 1
)

ECHO Operations completed successfully.
EXIT /B 0

REM A subroutine to perform git operations
:git_ops
CALL git add .
IF ERRORLEVEL 1 EXIT /B 1
CALL git commit -m "%~1"
IF ERRORLEVEL 1 EXIT /B 1
CALL git push -u origin master
IF ERRORLEVEL 1 EXIT /B 1
CALL git push -u dorg master
IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0

REM A subroutine to perform flutter and firebase operations
:flutter_firebase_ops
CALL flutter build web
IF ERRORLEVEL 1 EXIT /B 1
CALL firebase deploy --only hosting
IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0
