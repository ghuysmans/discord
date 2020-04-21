open Bot
open Dialog

let rec test () =
  get_user () >>= fun u ->
  send ("Hi " ^ u ^ "!") >>= fun () ->
  send "What's your favorite number?" >>= ask >>= function
    | Ping -> send "Not now, please..." >>= fun () -> test ()
    | Message "42" -> send "I knew it!" >>= fun () -> return true
    | Message _ -> send "Meh..." >>= fun () -> return false

let () =
  let a = ref @@ Interpreter.step @@ test () in
  let b = ref @@ Interpreter.step @@ test () in
  try
    while true do
      let m = read_line () in
      let u, target, m =
        if m.[0] = '&' then
          "Bob", b, String.(sub m 1 (length m - 1))
        else
          "Alice", a, m
      in
      match !target with
      | Return r -> Printf.printf "returned %b, ignoring the input\n" r
      | Ask f ->
        target := Lexer.tokenize m |> Parser.parse |> f |> Interpreter.step
      | User f -> target := f u |> Interpreter.step
      | _ -> Printf.printf "stuck\n"
    done
  with End_of_file ->
    ()
