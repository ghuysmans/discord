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
  | Ask f ->
    let d' = Lexer.tokenize message |> Parser.parse |> f |> step user in
    (match d' with
    | Return () ->
      Hashtbl.remove dialogs user;
      Done
    | _ ->
      Hashtbl.replace dialogs user d';
      Waiting)
  | Return () -> failwith "dropped message" (* FIXME *)
  | _ -> failwith "stuck" (* FIXME? *)
