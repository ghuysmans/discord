open Metabot

type e =
  | Message of string

let dialogs : (string, unit Dialog.t) Hashtbl.t = Hashtbl.create 10

let handler user init event =
  let rec step ?event user t =
    let () =
      let t =
        match t with
        | Dialog.Return _ -> "return"
        | Send _ -> "send"
        | Ask _ -> "ask"
        | User _ -> "user"
        | Switch_to _ -> "switch_to"
      in
      let event =
        match event with
        | Some (Message _) -> "message"
        | None -> "step"
      in
      prerr_endline @@ "::: " ^ t ^ ", " ^ event
    in
    match t, event with
    | Dialog.Return (), None -> ()
    | Send (s, f), None ->
      print_endline ("-> " ^ user ^ ": " ^ s);
      step user (f ())
    | Ask f, Some (Message text) ->
      Lexer.tokenize text |> Parser.parse |> f |> step user
    | Ask _, None ->
      Hashtbl.replace dialogs user t
    | User f, None ->
      f user |> step user
    | Switch_to (user', f), None ->
      step user' (f ())
    | t, _ -> (* FIXME? *)
      Hashtbl.replace dialogs user t
  in
  match Hashtbl.find_opt dialogs user with
  | None -> init () |> step ~event user
  | Some t -> Hashtbl.remove dialogs user; step ~event user t
