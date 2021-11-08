@echo off

set SHARDS=3
set CONFIG=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config

call ".\Stop.bat"
call ".\Drop.bat"


echo.
SET /P ANSWER=Deploy new PSA Cluster (y/n)? 
if /i {%ANSWER%}=={n} (
	GOTO :EOF
)


@echo off


@echo ************************************************************
@echo Install Services
@echo ************************************************************

FOR /L %%A IN (1,1,%CONFIG%) DO (
	mkdir %DATA_BASE_DIR%\mongocfg_%%A
	mongod.exe --config %CONFIG_BASE_DIR%\mongocfg_%%A.cfg --install
)
FOR /L %%A IN (1,1,%SHARDS%) DO (
	mkdir %DATA_BASE_DIR%\mongoshard_%%Ap
	mkdir %DATA_BASE_DIR%\mongoshard_%%As
	mkdir %DATA_BASE_DIR%\mongoshard_%%Aa
	mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%Ap.cfg --install
	mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%As.cfg --install
	mongod.exe --config %CONFIG_BASE_DIR%\mongoshard_%%Aa.cfg --install
)
mongos.exe --config %CONFIG_BASE_DIR%\mongos.cfg --install


@echo ************************************************************
@echo Start service and initialize ReplicaSets
@echo ************************************************************

FOR /L %%A IN (1,1,%CONFIG%) DO net start MongoDB_Config_%%A


@echo ************************************************************
@echo Initialize Config-Server ReplicatSet
@echo ************************************************************
mongo --norc localhost:27029 .\Config.js

@echo ************************************************************
@echo Start Shard-Server ReplicatSet services
@echo ************************************************************
FOR /L %%A IN (1,1,%SHARDS%) DO (
	net start MongoDB_Shard_%%Ap
	net start MongoDB_Shard_%%As
	net start MongoDB_Shard_%%Aa
)


@echo ************************************************************
@echo Initialize Shard-Server ReplicatSet
@echo ************************************************************
SETLOCAL EnableDelayedExpansion
SET PORT=27028
FOR /L %%A IN (1,1,%SHARDS%) DO (
	mongo --norc localhost:!PORT! --eval "p = !PORT!; shardId = 'shard_0%%A';" .\Shard_PSA.js
	SET /A "PORT=PORT+10" 
)



@echo ************************************************************
@echo Start MongoDB Router
@echo ************************************************************
net start MongoDB_Router

@echo ************************************************************
@echo Create admin user
@echo ************************************************************
mongo --norc localhost:27027 --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"


@echo ************************************************************
@echo Add Shards
@echo ************************************************************
mongo -u admin -p manager --authenticationDatabase admin --norc localhost:27027/admin --eval "for (i = 1; i <= 3; i++) { sh.addShard('shard_0'+i+'/localhost:' + (27018 + 10*i)) }"


@echo ************************************************************
@echo Print Sharded Cluster members
@echo ************************************************************
mongo -u admin -p manager --authenticationDatabase admin --norc localhost:27027/admin --eval "db.adminCommand('getShardMap').map"



