open Bot
open Dialog

let rec ask_message () =
  let* ans = ask () in
  match ans with
  | Ping ->
    let* () = send "Not now, please..." in
    ask_message ()
  | Message m ->
    return m

let test () =
  let* _ = ask () in
  let* u = get_user () in
  let* () = send ("Hi " ^ u ^ "!") in
  let* () = send "What's your favorite number?" in
  let* fav = ask_message () in
  let* () = send "Who do you want to play with?" in
  let* u' = ask_message () in
  let* () = switch_to u' in
  let* () = send (u^" asks what's your favorite number.") in
  let* fav' = ask_message () in
  let tell_result () =
    if fav = fav' then
      send "You share the same favorite number!"
    else
      send "You have different favorite numbers."
  in
  let* () = tell_result () in
  let* () = switch_to u in
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
