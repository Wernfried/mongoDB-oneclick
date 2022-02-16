@echo off

call ".\Drop.bat"

set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config


echo.
SET /P ANSWER=Deploy new MongoDB_Standalone Service (y/n)? 
if /i {%ANSWER%}=={n} (
	GOTO :EOF
)


@echo off

@echo ************************************************************
@echo Install Services
@echo ************************************************************

mkdir "%CONFIG_BASE_DIR%\mongod"
mongod.exe --config "%CONFIG_BASE_DIR%\mongod.cfg" --install


@echo ************************************************************
@echo Start service and initialize
@echo ************************************************************

net start MongoDB_Standalone

mongo --norc localhost:27017 CreateUsers.js --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"











