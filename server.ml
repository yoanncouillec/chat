let create_server port = 
  (*let addr = (Unix.gethostbyname(Unix.gethostname())).Unix.h_addr_list.(0) in*)
  (*let addr = Unix.gethostbyname "192.168.1.83" in*)
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

let main = 
  let port = ref 9900 in
  let options =
    [
     "-p", Arg.Set_int port, "Port of the server"
    ] in
  Arg.parse options (fun _ -> ()) "Options:";
  let name = Service.ask_for_name () in
  let server = create_server !port in
  let inc, outc = accept_client server in
  Service.receive_handshake inc ;
  Service.send_handshake outc ;
  ignore(Thread.create Service.send_service (name, inc, outc)) ;
  Service.receive_service (name, inc, outc)
