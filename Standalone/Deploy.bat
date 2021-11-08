
set DATA_BASE_DIR=c:\MongoDB\data
set CONFIG_BASE_DIR=c:\MongoDB\config

net stop MongoDB_Standalone
sc config MongoDB_Standalone start=disabled
mongod.exe --config %CONFIG_BASE_DIR%\mongod.cfg --remove
rmdir /S %DATA_BASE_DIR%\mongod


mkdir %CONFIG_BASE_DIR%\mongod
mongod.exe --config %CONFIG_BASE_DIR%\mongod.cfg --install

net start MongoDB_Standalone

mongo --norc localhost:27017 CreateUsers.js --eval "db.getSiblingDB('admin').createUser({ user: 'admin', pwd: 'manager', roles: ['root'] })"







