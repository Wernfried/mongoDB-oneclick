@echo off

call "%~dp0\Stop.bat"

set MEMBERS=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


@echo ************************************************************
@echo Remove Services
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO (
	FOR /F %%B IN ('sc query MongoDB_ReplicaSet_%%A ^| find "SERVICE_NAME"') DO (
		sc config MongoDB_ReplicaSet_%%A start=disabled
		mongod.exe --config "%CONFIG_BASE_DIR%\mongors_%%A.cfg" --remove
		REM Alternative way to delete service:
		REM sc.exe delete MongoDB_ReplicaSet_%%A
		rmdir /S /Q "%DATA_BASE_DIR%\mongors_%%A"
	)

	rmdir /S /Q "%DATA_BASE_DIR%\mongors_%%A"
)

