(* Parsite types, courtesy of faber-1 *)

(* Result type, used as parser output. Essentially either, but left type takes a 
   string. Also in monad shape!*)

type ('a, 'b) result = 
  | Win of ('b * 'a)
  | Lose of string

module ResultM = struct
  let return (x : 'b * 'a) : ('a, 'b) result = 
    Win x

  let (>>=) (m : ('a, 'b) result) (f : ('b * 'a) -> ('a, 'c) result ) : ('a, 'c) result =
    match m with 
    | Win e -> f e
    | Lose _ as l-> l
end

type ('a, 'b) p_func = 'a -> ('a, 'b) result