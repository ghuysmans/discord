open Bot

type state =
  | Done
  | Waiting

let dialogs : (string, unit Dialog.t) Hashtbl.t = Hashtbl.create 10

let rec step user = function
  | Dialog.Send (s, f) -> print_endline s; step user (f ())
  | User f -> step user (f user)
  | stuck -> stuck

let update init user message =
  let d =
    match Hashtbl.find_opt dialogs user with
    | None -> step user (init ())
    | Some d -> d
  in
  match d with
  | Return () ->
    Hashtbl.remove dialogs user;
    Done
  | Ask f ->
    Lexer.tokenize message |> Parser.parse |> f |> step user |>
    Hashtbl.replace dialogs user;
    Waiting
  | _ -> failwith "stuck" (* FIXME? *)
