let create_server port = 
  let socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let address = Unix.inet_addr_of_string "127.0.0.1" in 
  Unix.bind socket (Unix.ADDR_INET(address, port)) ;
  Unix.listen socket 100 ;
  Log.log ("Server created on port "^(string_of_int port));
  socket

let accept_client socket =   
  let client = Unix.accept socket in
  let channels = fst client in
  let addr = Unix.getnameinfo (snd client) [Unix.NI_NUMERICHOST] in
  Log.log ("Client accepted "^(addr.Unix.ni_hostname)^":"^(addr.Unix.ni_service));
  (Unix.in_channel_of_descr channels, Unix.out_channel_of_descr channels)

let main = 
  let port = ref 9900 in
  let options =
    [
     "--port", Arg.Set_int port, "Port of the server"
    ] in
  Arg.parse options (fun _ -> ()) "Options:";
  let name = Service.ask_for_name () in
  let server = create_server !port in
  let inc, outc = accept_client server in
  Service.receive_handshake inc ;
  Service.send_handshake outc ;
  ignore(Thread.create Service.send_service (name, inc, outc)) ;
  Service.receive_service (name, inc, outc)
