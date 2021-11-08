rs.initiate(
  {
    _id: "configRepSet",
    configsvr: true,
    members: [
      { _id: 0, host: "localhost:27029", priority: 10 },
      { _id: 1, host: "localhost:27039", priority: 5 },
      { _id: 2, host: "localhost:27049", priority: 5 }
    ]
  }
)
rs.status()
while (! db.hello().isWritablePrimary ) { sleep(1000) }

