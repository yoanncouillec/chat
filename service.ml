type name = string

type message = 
  | HandShake
  | Message of name * string
  | Quit

let ask_for_name () =  
  print_string "What's your name? ";
  flush stdout;
  let name = input_line stdin in
  name

let send outc msg =
  Marshal.to_channel outc msg [] ;
  flush outc ;
  Log.log "Message sent"
	
let send_handshake outc =
  send outc HandShake ;
  Log.log "Handshake sent"

let receive_handshake inc =
  match Marshal.from_channel inc with
  | HandShake ->   Log.log "Handshake received"
  | _ -> failwith "Wrong protocol from client"
		  
let rec send_service (name, inc, outc) = 
  print_string ("("^name^") ") ;
  flush stdout ;
  match input_line stdin with
  | "quit" 
  | "bye" -> 
     send outc Quit
  | _ as msg -> 
     send outc (Message (name, msg)) ;
     send_service (name, inc, outc)

let rec receive_service (local_name, inc, outc) = 
  let msg = Marshal.from_channel inc in
  match msg with 
  | Message (name, msg) -> 
     Log.log "Message received" ;
     print_endline ("\r("^name^") "^msg) ;
     print_string ("("^local_name^") ") ;
     flush stdout ;
     receive_service (local_name, inc, outc)
  | Quit -> 
     Log.log "Quit message received" ;
     send outc Quit
  | _ -> failwith "Wrong protocol from client"

