open Bot
open Dialog

let rec test () =
  send "What's your favorite number?" >>= ask >>= function
    | Ping -> send "Not now, please..." >>= fun () -> test ()
    | Message "42" -> send "I knew it!" >>= fun () -> return true
    | Message _ -> send "Meh..." >>= fun () -> return false

let () =
  if Interpreter.run (test ()) then
    print_endline "right"
  else
    print_endline "wrong"
