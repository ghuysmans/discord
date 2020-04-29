open Metabot
open Dialog

let rec ask_message () =
  ask () >>= function
    | Ping -> send "Not now, please..." >>= fun () -> ask_message ()
    | Message m -> return m

let test () =
  ask () >>= fun _ ->
  get_user () >>= fun u ->
  send ("Hi " ^ u ^ "!") >>= fun () ->
  send "What's your favorite number?" >>= ask_message >>= fun fav ->
  send "Who do you want to play with?" >>= ask_message >>= fun u' ->
  switch_to u' >>= fun () ->
  send (u^" asks what's your favorite number.") >>= ask_message >>= fun fav' ->
  let tell_result () =
    if fav = fav' then
      send "You share the same favorite number."
    else
      return ()
  in
  tell_result () >>= fun () ->
  switch_to u >>= fun () ->
  tell_result ()


let () =
  try
    while true do
      let m = read_line () in
      let user, text =
        if m.[0] = '&' then
          "Bob", String.(sub m 1 (length m - 1))
        else
          "Alice", m
      in
      Interpreter.(handler user test (Message text))
    done
  with End_of_file ->
    ()
