@echo off

set SHARDS=3
set CONFIG=3

@echo ************************************************************
@echo Stop Services
@echo ************************************************************

FOR /F %%B IN ('sc query MongoDB_Router ^| find "SERVICE_NAME"') DO sc stop MongoDB_Router
FOR /L %%A IN (1,1,%CONFIG%) DO (
	FOR /F %%B IN ('sc query MongoDB_Config_%%A ^| find "SERVICE_NAME"') DO sc stop MongoDB_Config_%%A
)
FOR /L %%A IN (1,1,%SHARDS%) DO (
	FOR /F %%B IN ('sc query MongoDB_Shard_%%Ap ^| find "SERVICE_NAME"') DO sc stop MongoDB_Shard_%%Ap
	FOR /F %%B IN ('sc query MongoDB_Shard_%%As ^| find "SERVICE_NAME"') DO sc stop MongoDB_Shard_%%As
	FOR /F %%B IN ('sc query MongoDB_Shard_%%Aa ^| find "SERVICE_NAME"') DO sc stop MongoDB_Shard_%%Aa
)


