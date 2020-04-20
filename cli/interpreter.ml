open Bot

let rec run = function
  | Dialog.Return x -> x
  | Send (s, f) -> print_endline s; run (f ())
  | Ask f ->
    print_string "> ";
    run (f (read_line () |> Lexer.tokenize |> Parser.parse))
