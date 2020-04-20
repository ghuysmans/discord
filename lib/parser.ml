open Ast
exception Syntax_error

let parse = function
  | ["!ping"] -> Ping
  | h :: _ as l ->
    if h = "" || h.[0] <> '!' then
      Message (String.concat " " l)
    else
      raise Syntax_error
  | [] -> Message "" (* this doesn't happen anyway *)
