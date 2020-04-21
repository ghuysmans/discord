type 'a t =
  | Return of 'a
  | Send of string * (unit -> 'a t)
  | Ask of (Ast.t -> 'a t)
  | User of (string -> 'a t)

let rec (>>=) t f =
  match t with
  | Return x -> f x
  | Send (s, g) -> Send (s, fun () -> g () >>= f)
  | Ask g -> Ask (fun ast -> g ast >>= f)
  | User g -> User (fun u -> g u >>= f)

let return x = Return x
let send s = Send (s, return)
let ask () = Ask return
let get_user () = User return
