@echo off

set SHARDS=3
set CONFIG=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config

call ".\Stop.bat"


@echo ************************************************************
@echo Remove Services
@echo ************************************************************

FOR /F %%B IN ('sc query MongoDB_Router ^| find "SERVICE_NAME"') DO (
	sc config MongoDB_Router start=disabled
	mongos.exe --config %CONFIG_BASE_DIR%\mongos.cfg --remove
)
FOR /L %%A IN (1,1,%CONFIG%) DO (
	FOR /F %%B IN ('sc query MongoDB_Config_%%A ^| find "SERVICE_NAME"') DO (
		sc config MongoDB_Config_%%A start=disabled
		mongod.exe --config %CONFIG_BASE_DIR%\mongocfg_%%A.cfg --remove
	)
	rmdir /S /Q %DATA_BASE_DIR%\mongocfg_%%A
)

FOR /L %%A IN (1,1,%SHARDS%) DO (
	FOR /F %%B IN ('sc query MongoDB_Shard_%%Ap ^| find "SERVICE_NAME"') DO (
		sc config MongoDB_Shard_%%Ap start=disabled
		mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%Ap.cfg --remove
	)
	FOR /F %%B IN ('sc query MongoDB_Shard_%%As ^| find "SERVICE_NAME"') DO (
		sc config MongoDB_Shard_%%As start=disabled
		mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%As.cfg --remove
	)
	FOR /F %%B IN ('sc query MongoDB_Shard_%%Aa ^| find "SERVICE_NAME"') DO (
		sc config MongoDB_Shard_%%Aa start=disabled
		mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%Aa.cfg --remove
	)

	rmdir /S /Q %DATA_BASE_DIR%\mongoshard_%%Ap
	rmdir /S /Q %DATA_BASE_DIR%\mongoshard_%%As
	rmdir /S /Q %DATA_BASE_DIR%\mongoshard_%%Aa

)





