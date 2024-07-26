(* Parsite types, courtesy of faber-1 *)

(* Result type, used as parser output. Essentially either, but left type takes a 
   string. Also in monad shape!*)

type ('a, 'b) p_result = 
  | Win of ('b * 'a)
  | Lose of string

module PResultM = struct
  let return (x : 'b * 'a) : ('a, 'b) p_result = 
    Win x

  let (>>=) (m : ('a, 'b) p_result) (f : ('b * 'a) -> ('a, 'c) p_result ) : ('a, 'c) p_result =
    match m with 
    | Win e -> f e
    | Lose _ as l-> l
end

type ('a, 'b) p_func = 'a -> ('a, 'b) p_result