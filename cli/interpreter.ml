open Bot

let rec step = function
  | Dialog.Send (s, f) -> print_endline s; step (f ())
  | stuck -> stuck
