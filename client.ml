let connect_to_server hostname port = 
  let socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let address = Unix.inet_addr_of_string hostname in 
  Unix.connect socket (Unix.ADDR_INET(address, port));
  (Unix.in_channel_of_descr socket, Unix.out_channel_of_descr socket)

let main =
  let hostname = ref "127.0.0.1" in
  let port = ref 9900 in
  let options =
    [
      ("-h", Arg.Set_string hostname, "Hostname of the server");
      ("-p", Arg.Set_int port, "Port of the server");
    ] in
  Arg.parse options print_endline "Chat client:" ;
  let name = Service.ask_for_name () in
  let inc, outc = connect_to_server !hostname !port in
  Service.send_handshake outc ;
  Service.receive_handshake inc ;
  ignore(Thread.create Service.send_service (name, inc, outc)) ;
  Service.receive_service (name, inc, outc)

