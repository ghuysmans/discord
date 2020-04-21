open Bot
open Lwt.Infix

let rec run = function
  | Dialog.Return x -> Lwt.return x
  | Send (s, f) -> Lwt_io.printl s >>= fun () -> run (f ())
  | User f -> run (f "dummy")
  | Ask f ->
    Lwt_io.(read_line stdin >|= Lexer.tokenize >|= Parser.parse) >>= fun x ->
    run (f x)
