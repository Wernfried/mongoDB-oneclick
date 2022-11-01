@echo off

call "%~dp0Stop.bat"

set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


@echo ************************************************************
@echo Remove Services
@echo ************************************************************

FOR /F %%B IN ('sc query MongoDB_Standalone ^| find "SERVICE_NAME"') DO (
	sc config MongoDB_Standalone start=disabled
	REM Alternative way to delete service:
	REM sc.exe delete MongoDB_Standalone
	mongod.exe --config "%CONFIG_BASE_DIR%\mongod.cfg" --remove
)

rmdir /S /Q "%DATA_BASE_DIR%\mongod"


