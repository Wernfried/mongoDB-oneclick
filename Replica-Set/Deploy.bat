@echo off

call "%~dp0Drop.bat"

set MEMBERS=3
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


echo.
SET /P ANSWER=Deploy new ReplicaSet (y/n)? 
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

FOR /L %%A IN (1,1,%MEMBERS%) DO (
	mkdir "%DATA_BASE_DIR%\mongors_%%A"
	mongod.exe --config "%CONFIG_BASE_DIR%\mongors_%%A.cfg" --install
)

@echo ************************************************************
@echo Start service and initialize ReplicaSets
@echo ************************************************************

FOR /L %%A IN (1,1,%MEMBERS%) DO net start MongoDB_ReplicaSet_%%A

@echo Initialize ReplicatSet
mongosh "mongodb://localhost:27037/admin?readPreference=primaryPreferred" "%~dp0ReplicaSet.js"
mongosh "mongodb://localhost:27037/admin?readPreference=primaryPreferred" --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"



