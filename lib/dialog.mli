type 'a t =
  | Return of 'a
  | Send of string * (unit -> 'a t)
  | Ask of (Ast.t -> 'a t)

val (>>=) : 'a t -> ('a -> 'b t) -> 'b t

val return : 'a -> 'a t
val send : string -> unit t
val ask : unit -> Ast.t t
