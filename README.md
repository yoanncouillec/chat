Chat
============

Chat is a chat based on client/server architecture and written in OCaml

## Build

```make```

It generates two binaries `server.out` and `client.out`

### Run

Run the server with:

```
./server.out [--port <port>]
```

Default port is 9900.

Run the client with:

```
./client.out [--host <hostname>][--port <port>]
```

Default port is 9900. Default hostname is localhost.

### Dialog

You are first ask to enter your name.
Then you can chat.
When you are done type "quit" or "bye". This will end the communication in both ways.
