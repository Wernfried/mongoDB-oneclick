rs.initiate(
  {
    _id: shardId,
    members: [
      { _id: 0, host: "localhost:" + p, priority: 10 },
      { _id: 1, host: "localhost:" + (p*1+100), priority: 5 },
      { _id: 2, host: "localhost:" + (p*1+200), arbiterOnly: true }
    ]
  }
)
rs.status()
while (! db.hello().isWritablePrimary ) { sleep(1000) }
admin = db.getSiblingDB("admin")
admin.createUser({ user: "admin", pwd: "manager", roles: ["clusterAdmin", "userAdminAnyDatabase"] })
admin.auth("admin", "manager")
admin.grantRolesToUser("admin", ["dbAdminAnyDatabase", { role: "dbAdmin", db: "local" }])

