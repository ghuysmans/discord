open Async
open Core
open Disml
open Models

let check_command (message:Message.t) =
  if String.is_prefix ~prefix:"!ping" message.content then
    Message.reply message "Pong!" >>> ignore


let _ =
  let main () =
    Client.message_create := check_command;
    Client.start (Sys.getenv_exn "TOKEN") >>> ignore
  in
  Scheduler.go_main ~main ()
