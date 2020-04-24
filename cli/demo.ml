open Bot
open Dialog

let rec ask_message () = do_;
  match%m ask () with
  | Ping -> do_;
    send "Not now, please...";
    ask_message ()
  | Message m ->
    return m

let test () = do_;
  let%m _ = ask () in
  u <-- get_user ();
  send ("Hi " ^ u ^ "!");
  send "What's your favorite number?";
  fav <-- ask_message ();
  send "Who do you want to play with?";
  u' <-- ask_message ();
  switch_to u';
  send (u^" asks what's your favorite number.");
  fav' <-- ask_message ();
  let tell_result () =
    if fav = fav' then
      send "You share the same favorite number."
    else
      return ()
  in
  tell_result ();
  switch_to u;
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
