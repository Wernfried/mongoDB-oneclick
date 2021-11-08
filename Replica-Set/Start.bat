@echo off

set MEMBERS=3

@echo ************************************************************
@echo Start Services
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO (
	FOR /F %%B IN ('sc query MongoDB_ReplicaSet_%%A ^| find "SERVICE_NAME"') DO sc start MongoDB_ReplicaSet_%%A
)


