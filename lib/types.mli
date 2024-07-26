(* Parsite types, courtesy of faber-1 *)

(**
A result type is what a parser will return after running. It takes types 'a 
and 'b where 'a is the type of the input that is being parsed, and 'b is the type
of the output of your parsing.

The result type is constructed with either a Win constructor that holds a ('b * 'a) 
tuple or a List constructor that holds an error message.

The input and output types are both variable types in case you want to 
make your own parser with custom types!
*)
type ('a, 'b) p_result = Win of ('b * 'a) | Lose of string

(**
There's also the ResultM monad which has a return function that wrapps its 
input in a Win constructor, and the bind (>>=) operator which applies a 
function to a result value if that value is a Win value.

It's a basic monad but it helped string a few things along easier.
*)
module PResultM :
  sig
    val return : 'b * 'a -> ('a, 'b) p_result
    val ( >>= ) :
      ('a, 'b) p_result -> ('b * 'a -> ('a, 'c) p_result) -> ('a, 'c) p_result
  end

(**
The p_func type is the type signature for parser functions. Like result, it 
takes in types 'a and 'b where 'a is the type of the input and 'b is the type of
the output.   
*)
type ('a, 'b) p_func = 'a -> ('a, 'b) p_result
