Chat
============

Chat is a chat based on client/server architecture and written in OCaml

## Build

```make```

It generates two binaries `server.out` and `client.out`

### Run

Run the server with:

```
./chat.out --server [--port <port>]
```

Default port is 9900.

Run the client with:

```
./chat.out --client [--host <hostname>][--port <port>]
```

Default port is 9900. Default hostname is localhost.

### Dialog

You are first ask to enter your name.
Then you can chat.
When you are done type "quit" (or "bye", "exit", "q", "b"). This will end the communication in both ways.

### Command-line example of dialog

Server:

```shell
couillec@yoann ~/Documents/Ocaml/Src/chat> ./chat.out --server
What's your name? Alice
[2017-11-31 15:6:01.682363 Server created on port 9900]
[2017-11-31 15:6:07.238338 Client accepted 127.0.0.1:51043]
[2017-11-31 15:6:07.238401 HandShake received]
[2017-11-31 15:6:07.238452 HandShake sent]
(Alice) Hi Bob!
[2017-11-31 15:6:12.570436 Message(#1, Alice, "Hi Bob!") sent]
[2017-11-31 15:6:12.570595 Ack(#1) received]
[2017-11-31 15:6:12.570650 Round trip time for #1 is 0.000269174575806s]
[2017-11-31 15:6:22.890260 Message(#1, Bob, "Hi Alice! How are you?") received]
[2017-11-31 15:6:22.890315 Ack(#1) sent]
(Bob) Hi Alice! How are you?
(Alice) Perfect! Thank you!
[2017-11-31 15:6:43.122344 Message(#2, Alice, "Perfect! Thank you!") sent]
[2017-11-31 15:6:43.122550 Ack(#2) received]
[2017-11-31 15:6:43.122611 Round trip time for #2 is 0.000313997268677s]
(Alice) Have to go
[2017-11-31 15:6:59.177843 Message(#3, Alice, "Have to go") sent]
[2017-11-31 15:6:59.178096 Ack(#3) received]
[2017-11-31 15:6:59.178160 Round trip time for #3 is 0.000360012054443s]
(Alice) bye
[2017-11-31 15:7:02.721820 Quit sent]
[2017-11-31 15:7:02.721976 Quit received]
```

Client:

```shell
couillec@yoann ~/Documents/Ocaml/Src/chat> ./chat.out --client
What's your name? Bob
[2017-11-31 15:6:07.226500 HandShake sent]
[2017-11-31 15:6:07.238552 HandShake received]
[2017-11-31 15:6:12.570489 Message(#1, Alice, "Hi Bob!") received]
[2017-11-31 15:6:12.570545 Ack(#1) sent]
(Alice) Hi Bob!
(Bob) Hi Alice! How are you?
[2017-11-31 15:6:22.890197 Message(#1, Bob, "Hi Alice! How are you?") sent]
[2017-11-31 15:6:22.890348 Ack(#1) received]
[2017-11-31 15:6:22.890413 Round trip time for #1 is 0.000235080718994s]
[2017-11-31 15:6:43.122406 Message(#2, Alice, "Perfect! Thank you!") received]
[2017-11-31 15:6:43.122502 Ack(#2) sent]
(Alice) Perfect! Thank you!
[2017-11-31 15:6:59.177933 Message(#3, Alice, "Have to go") received]
[2017-11-31 15:6:59.178004 Ack(#3) sent]
(Alice) Have to go
[2017-11-31 15:7:02.721872 Quit received]
[2017-11-31 15:7:02.721935 Quit sent]
```