rs.initiate(
  {
    _id: "repSet",
    members: [
      { _id: 0, host: "localhost:27037" },
      { _id: 1, host: "localhost:27137" },
      { _id: 2, host: "localhost:27237" }
    ]
  }
)
rs.status()

while (! db.hello().isWritablePrimary ) { sleep(1000) }


