@echo off

call ".\Drop.bat"

set MEMBERS=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


echo.
SET /P ANSWER=Deploy new ReplicaSet (y/n)? 
if /i {%ANSWER%}=={n} (
	GOTO :EOF
)


@echo off


@echo ************************************************************
@echo Install Services
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO (
	mkdir %DATA_BASE_DIR%\mongors_%%A
	mongod.exe --config %CONFIG_BASE_DIR%\mongors_%%A.cfg --install
)

@echo ************************************************************
@echo Start service and initialize ReplicaSets
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO net start MongoDB_ReplicaSet_%%A

@echo Initialize ReplicatSet
mongo --norc localhost:27037 .\ReplicaSet.js
mongo --norc localhost:27037 --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"



