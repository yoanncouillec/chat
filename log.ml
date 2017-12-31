open Unix

let string_of_time tm =
  let t = gmtime tm in
  let us = int_of_float (1000000.0 *. (tm -. (float_of_int (int_of_float tm)))) in
  (string_of_int (1900 + t.tm_year))^"-"^(string_of_int t.tm_mon)^"-"^(string_of_int t.tm_mday)^" "^(string_of_int t.tm_hour)^":"^(string_of_int t.tm_min)^":"^((if t.tm_sec < 10 then "0" else "")^(string_of_int t.tm_sec))^"."^(string_of_int us)

let log msg = 
  print_endline ("\r["^(string_of_time (gettimeofday()))^" "^msg^"]")
