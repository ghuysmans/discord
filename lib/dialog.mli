type 'a t =
  | Return of 'a
  | Send of string * (unit -> 'a t)
  | Ask of (Ast.t -> 'a t)
  | User of (string -> 'a t)
  | Switch_to of string * (unit -> 'a t)

val (>>=) : 'a t -> ('a -> 'b t) -> 'b t
val bind : 'a t -> ('a -> 'b t) -> 'b t

val return : 'a -> 'a t
val send : string -> unit t
val ask : unit -> Ast.t t
val get_user : unit -> string t
val switch_to : string -> unit t
