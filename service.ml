type id = string
type time = float
type name = string

type message = 
  | HandShake
  | Message of id * name * string
  | Quit
  | Ack of id

let history:(id * time) list ref = ref []

let string_of_message = function
  | HandShake -> "HandShake"
  | Message (id, n, s) -> "Message(#"^id^", "^n^", \""^s^"\")"
  | Quit -> "Quit"
  | Ack id -> "Ack(#"^id^")"

let ask_for_name () =  
  print_string "What's your name? ";
  flush stdout;
  let name = input_line stdin in
  name

let send outc msg =
  Marshal.to_channel outc msg [] ;
  flush outc ;
  Log.log ((string_of_message msg)^" sent")

let receive_handshake inc =
  match Marshal.from_channel inc with
  | HandShake as msg -> Log.log ((string_of_message msg)^" received")
  | _ -> failwith "receive_handshake: Wrong protocol"

let rec send_service (name, inc, outc) = 
  print_string ("("^name^") ") ;
  flush stdout ;
  match input_line stdin with
  | "quit" 
  | "bye" 
  | "exit"
  | "q" 
  | "b" -> 
     send outc Quit
  | _ as content -> 
     let id = Gensym.next () in
     history := (id, Unix.gettimeofday())::!history ;
     send outc (Message (id, name, content)) ;
     send_service (name, inc, outc)

let rec receive_service (local_name, inc, outc) = 
  let msg = Marshal.from_channel inc in
  Log.log ((string_of_message msg)^" received") ;
  match msg with 
  | Message (id, name, content) -> 
     send outc (Ack id) ;
     print_endline ("\r("^name^") "^content) ;
     print_string ("("^local_name^") ") ;
     flush stdout ;
     receive_service (local_name, inc, outc)
  | Quit -> 
     send outc Quit
  | Ack id -> 
     let sent_time = List.assoc id !history in
     let received_time = Unix.gettimeofday () in
     let round_trip_time = received_time -. sent_time in
     Log.log ("Round trip time for #"^id^ " is "^(string_of_float round_trip_time)^"s") ;
     print_string ("("^local_name^") ") ;
     flush stdout ;
     receive_service (local_name, inc, outc)
  | _ as msg -> failwith ("receive_service: Wrong protocol: "^(string_of_message msg))

