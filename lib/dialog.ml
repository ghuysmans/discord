type 'a t =
  | Return of 'a
  | Send of string * (unit -> 'a t)
  | Ask of (Ast.t -> 'a t)

let rec (>>=) t f =
  match t with
  | Return x -> f x
  | Send (s, g) -> Send (s, fun () -> g () >>= f)
  | Ask g -> Ask (fun ast -> g ast >>= f)

let return x = Return x
let send s = Send (s, fun () -> return ())
let ask () = Ask (fun x -> return x)
