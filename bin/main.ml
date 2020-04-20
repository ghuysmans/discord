open Async
open Core
open Disml
open Models

let check_command (message:Message.t) =
  match Bot.Lexer.tokenize message.content |> Bot.Parser.parse with
  | Bot.Ast.Ping ->
    Message.reply message "Pong!" >>> ignore
  | Message m ->
    print_endline m


let _ =
  let main () =
    Client.message_create := check_command;
    Client.start (Sys.getenv_exn "TOKEN") >>> ignore
  in
  Scheduler.go_main ~main ()
