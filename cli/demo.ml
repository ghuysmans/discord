open Bot
open Dialog

let rec test () =
  ask () >>= fun _ ->
  get_user () >>= fun u ->
  send ("Hi " ^ u ^ "!") >>= fun () ->
  send "What's your favorite number?" >>= ask >>= function
    | Ping -> send "Not now, please..." >>= fun () -> test ()
    | Message "42" -> send "I knew it!"
    | Message _ -> send "Meh..."

let () =
  try
    while true do
      let m = read_line () in
      let u, m =
        if m.[0] = '&' then
          "Bob", String.(sub m 1 (length m - 1))
        else
          "Alice", m
      in
      match Interpreter.update test u m with
      | Waiting -> ()
      | Done -> Printf.printf "done.\n"
    done
  with End_of_file ->
    ()
