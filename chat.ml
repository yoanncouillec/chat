let create_server port = 
  let addr = Unix.inet_addr_any in
  let saddr = Unix.ADDR_INET(addr,port) in
  let socket = Unix.socket (Unix.domain_of_sockaddr saddr) Unix.SOCK_STREAM 0 in
   Unix.bind socket saddr ;
   Unix.listen socket 100 ;
   Log.log ("Server created on port "^(string_of_int port));
   socket

let accept_client socket =   
  let client = Unix.accept socket in
  let channels = fst client in
  let addr = Unix.getnameinfo (snd client) [Unix.NI_NUMERICHOST] in
  Log.log ("Client accepted "^(addr.Unix.ni_hostname)^":"^(addr.Unix.ni_service));
  (Unix.in_channel_of_descr channels, Unix.out_channel_of_descr channels)

let connect_to_server hostname port = 
  let socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let address = Unix.inet_addr_of_string hostname in 
  Unix.connect socket (Unix.ADDR_INET(address, port));
  (Unix.in_channel_of_descr socket, Unix.out_channel_of_descr socket)

let main = 
  let server = ref false in
  let client = ref false in
  let hostname = ref "127.0.0.1" in
  let port = ref 9900 in
  let options =
    [
      ("--server", Arg.Set server, "Run in server mode");
      ("--client", Arg.Set client, "Run in client mode");
      ("--host", Arg.Set_string hostname, "Hostname of the server (if --server is set)");
      ("--port", Arg.Set_int port, "Port on which the application runs");
    ] in
  Arg.parse options (fun _ -> ()) "Options:";
  let name = Service.ask_for_name () in
  if !server && not !client then
    let server = create_server !port in
    let inc, outc = accept_client server in
    Service.receive_handshake inc ;
    Service.send outc Service.HandShake;
    ignore(Thread.create Service.send_service (name, inc, outc)) ;
    Service.receive_service (name, inc, outc)
  else if !client && not !server then
    let inc, outc = connect_to_server !hostname !port in
    Service.send outc Service.HandShake;
    Service.receive_handshake inc ;
    ignore(Thread.create Service.send_service (name, inc, outc)) ;
    Service.receive_service (name, inc, outc)
  else
    failwith "Wrong options. Must be ran either with --server or --client"
