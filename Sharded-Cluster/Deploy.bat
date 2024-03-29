@echo off

set SHARDS=3
set CONFIG=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


call "%~dp0Drop.bat"


echo.
SET /P ANSWER=Deploy new PSA Cluster (y/n)? 
if /i {%ANSWER%}=={n} (
	GOTO :EOF
)


@echo off

IF NOT EXIST "%CONFIG_BASE_DIR%\mongo.key" (
   openssl.exe version >nul 2>&1
   IF ERRORLEVEL 1 (
      echo OpenSSL.exe not found. 
      echo Please download OpenSSL or create keyfile '%CONFIG_BASE_DIR%\mongo.key' manually
      GOTO :EOF
   )
   @echo Create keyfile %CONFIG_BASE_DIR%\mongo.key
   openssl.exe rand -base64 756 > "%CONFIG_BASE_DIR%\mongo.key"
)


@echo ************************************************************
@echo Install Services
@echo ************************************************************

FOR /L %%A IN (1,1,%CONFIG%) DO (
	mkdir "%DATA_BASE_DIR%\mongocfg_%%A"
	mongod.exe --config "%CONFIG_BASE_DIR%\mongoshard_conf_%%A.cfg" --install
)
FOR /L %%A IN (1,1,%SHARDS%) DO (
	mkdir "%DATA_BASE_DIR%\mongoshard_%%Ap"
	mkdir "%DATA_BASE_DIR%\mongoshard_%%As"
	mkdir "%DATA_BASE_DIR%\mongoshard_%%Aa"
	mongod.exe --config "%CONFIG_BASE_DIR%\mongoshard_%%Ap.cfg" --install
	mongod.exe --config "%CONFIG_BASE_DIR%\mongoshard_%%As.cfg" --install
	mongod.exe --config "%CONFIG_BASE_DIR%\mongoshard_%%Aa.cfg" --install
)
mongos.exe --config "%CONFIG_BASE_DIR%\mongoshard_s.cfg" --install


@echo ************************************************************
@echo Start service and initialize ReplicaSets
@echo ************************************************************

FOR /L %%A IN (1,1,%CONFIG%) DO net start MongoDB_Config_%%A


@echo ************************************************************
@echo Initialize Config-Server ReplicatSet
@echo ************************************************************
mongo --norc localhost:27029 "%~dp0Config.js"

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
	mongo --norc localhost:!PORT! --eval "p = !PORT!; shardId = 'shard_0%%A';" "%~dp0Shard_PSA.js"
	SET /A "PORT=PORT+10" 
)



@echo ************************************************************
@echo Start MongoDB Router
@echo ************************************************************
net start MongoDB_Router

@echo ************************************************************
@echo Create admin user
@echo ************************************************************
mongosh --norc localhost:27027 --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"


@echo ************************************************************
@echo Add Shards
@echo ************************************************************
mongosh -u admin -p manager --authenticationDatabase admin --norc localhost:27027/admin --eval "for (i = 1; i <= 3; i++) { sh.addShard('shard_0'+i+'/localhost:' + (27018 + 10*i)) }"


@echo ************************************************************
@echo Print Sharded Cluster members
@echo ************************************************************
mongosh -u admin -p manager --authenticationDatabase admin --norc localhost:27027/admin --eval "db.adminCommand('getShardMap').map"



