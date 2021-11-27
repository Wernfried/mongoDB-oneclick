# mongoDB-oneClick
Create MongoDB with a single click

MongoDB documentation provides tutorials to deploy a MongoDB on your machine. However, it might be a bit difficult if you start learning MongoDB.

Scrit and config files are based on 
- [Deploy Replica Set With Keyfile Authentication](https://docs.mongodb.com/manual/tutorial/deploy-replica-set-with-keyfile-access-control/) 
- [Deploy Sharded Cluster with Keyfile Authentication](https://docs.mongodb.com/manual/tutorial/deploy-sharded-cluster-with-keyfile-access-control/)

This repository provides ready-to-use scripts to deploy on your localhost
- Stand alone MongoDB
- Replicat Set 
  - with 3 members (as recommended by MongoDB)     
- Sharded Cluster 
  - with 3 member Config Server 
  - 3 Shards, each Shard as PSA-ReplicaSet (Primary-Secondary-Arbiter)

Run `Stop.bat`, `Drop.bat`, `Start.bat` and `Deploy.bat` from according sub folder.

# Usage
`.bat` files are Window Batch files. This repository is mainly intended for learning, testing and developing purpose.
Of course, feel free to use the config files as base for your production environment.

Script will install MongoDB as Service. Thus you must run the batch files with **Administrator** privileges!

Create your key file for internal authentication, see https://docs.mongodb.com/manual/tutorial/deploy-sharded-cluster-with-keyfile-access-control/#create-the-keyfile

# Configuration 

- All config files are placed in `c:\MongoDB\config\` 
  - modify `.cfg` and `.bat` files accordingly, if needed
- All log files are placed in `c:\MongoDB\log\` subfolders
  - modify `.cfg` and `.bat` files accordingly, if needed
- All data files are placed in `c:\MongoDB\data\` subfolders
  - modify `.cfg` and `.bat` files accordingly, if needed
- All mongo services are created on `localhost`
- All MongoDB's are created with Authentication (you should **never** deploy a MongoDB without Authentication)
- An admin user with root privilegers is created while setup
  - Username: `admin`
  - Password: `manager`
- Mongo services are configured on these ports:

```
mongod.cfg:  port: 27017

mongors_1.cfg:  port: 27037
mongors_2.cfg:  port: 27137
mongors_3.cfg:  port: 27237

mongoshard_s.cfg:  port: 27027
mongoshard_conf_1.cfg:  port: 27029
mongoshard_conf_2.cfg:  port: 27039
mongoshard_conf_3.cfg:  port: 27049
mongoshard_1p.cfg:  port: 27028
mongoshard_2p.cfg:  port: 27038
mongoshard_3p.cfg:  port: 27048
mongoshard_1s.cfg:  port: 27128
mongoshard_2s.cfg:  port: 27138
mongoshard_3s.cfg:  port: 27148
mongoshard_1a.cfg:  port: 27228
mongoshard_2a.cfg:  port: 27238
mongoshard_3a.cfg:  port: 27248
```





