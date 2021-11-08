@echo off

set MEMBERS=3

@echo ************************************************************
@echo Stop Services
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO (
	FOR /F %%B IN ('sc query MongoDB_ReplicaSet_%%A ^| find "SERVICE_NAME"') DO sc stop MongoDB_ReplicaSet_%%A
)

