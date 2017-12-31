let c = ref 0
let next () = 
  incr c ; 
  string_of_int !c
