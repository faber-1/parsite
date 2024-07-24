(* Result type, used as parser output. Essentially either, but left type takes a 
   string. Also in monad shape!*)

type 'a result = 
  | Win of 'a
  | Lose of string

module ResultM = struct
  let return (x : 'a) : 'a result = 
    Win x 

  let (>>=) (m : 'a result) (f : 'a -> 'b result) : 'b result =
    match m with 
    | Win a -> f a  
    | Lose _ as l-> l
end

(* Parser type and monad, wraps parsing function with signature 'a -> 'b result. The 'a 
   type can be an accumulator for parsers that don't accumulate strings. 'b can be
   anything, but for most of this library it is of type ('b * string). *)

type 'a parser = 
| Parser of 'a

module ParserM = struct
  let return (x : 'a): 'a parser = Parser x 

  let (>>=) (m : 'a parser) (f : 'a -> 'b parser) : 'b parser = 
    match m with 
    | Parser a -> f a
end

