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
CALL :git_ops_app "%COMMIT_MSG%"
IF ERRORLEVEL 1 (
    ECHO Git operations failed.
    EXIT /B 1
)

CD /D "functions" 

CALL :git_ops_functions "functions: %COMMIT_MSG%" "functions"
IF ERRORLEVEL 1 (
    ECHO Git operations for 'functions' failed.
    EXIT /B 1
)

REM Perform flutter and firebase operations

ECHO Operations completed successfully.
EXIT /B 0

REM A subroutine to perform git operations
:git_ops_app
CALL git add .
IF ERRORLEVEL 1 EXIT /B 1
CALL git commit -m "%~1"
IF ERRORLEVEL 1 EXIT /B 1
CALL git push -u origin master
IF ERRORLEVEL 1 EXIT /B 1
CALL git push -u dorg master
IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0


:git_ops_functions
CALL git add .
IF ERRORLEVEL 1 EXIT /B 1
CALL git commit -m "%~1"
IF ERRORLEVEL 1 EXIT /B 1
CALL git push -u origin master
IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0
