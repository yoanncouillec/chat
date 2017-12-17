open Unix

let string_of_int t =
  (string_of_int (1900 + t.tm_year))^"-"^(string_of_int t.tm_mon)^"-"^(string_of_int t.tm_mday)^" "^(string_of_int t.tm_hour)^":"^(string_of_int t.tm_min)^":"^((if t.tm_sec < 10 then "0" else "")^(string_of_int t.tm_sec))

let log msg = 
  print_endline ("\r["^(string_of_int (gmtime (time())))^" "^msg^"]")
