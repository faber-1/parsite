(** Parsite types, courtesy of faber-1 *)

(**
A [p_result] type is what a parser will return after running. It takes types ['a] 
and ['b] where ['a] is the type of the input that is being parsed, and ['b] is the type
of the output of your parsing.

The [p_result] type is constructed with either a [Win] constructor that holds a [('b * 'a)] 
tuple or a [Lose] constructor that holds an error message.

The input and output types are both variable types in case you want to 
make your own parser with custom types!
*)
type ('a, 'b) p_result = Win of ('b * 'a) | Lose of string

(**
There's also the [PResultM] monad which has a [return] function that wrapps its 
input in a [Win] constructor, and the bind [(>>=)] operator which applies a 
function to a [p_result] value if that value is a [Win] value.

Also includes a [fail] function that returns an error message, and [(=<<)] infix 
function to handle any [Lose] cases. 

It's a basic monad but it helped string a few things along easier.
*)
module PResultM :
  sig
    (** Takes in a tuple of type [('b * 'a)] and returns it wrapped in a [Win] 
        constructor

        {[
          return (b, a) = Win (b, a)
        ]}
        *)
    val return : 'b * 'a -> ('a, 'b) p_result

    (** Bind function, takes in a [p_result] and if the result is a [Win], the 
        function is applied to the tuple inside. If the result is a [Lose], the 
        result is just returned without any change. 

        {[
          Win (b, a) >>= fun (a1, a2) -> 
          (a1 = b) && (a2 = a)
        ]}
        
        *)
    val ( >>= ) :
      ('a, 'b) p_result -> ('b * 'a -> ('a, 'c) p_result) -> ('a, 'c) p_result

    (** Fail function that takes in a string and evaluates to [Lose] with that 
        string as a fail message 
        
        {[
          fail a -> Lose a
        ]}
        *)
    val fail : string -> ('a, 'b) p_result 

    (** A sort of reverse bind of sorts. Takes in a [p_result] and a function, and
        it applies the function to the string inside the result if the result is
        a [Lose]. 
        
        {[
          Lose a =<< fun a1 -> 
          (a = a1)
        ]}
        *)
    val ( =<< ) :
      ('a, 'b) p_result -> (string -> ('a, 'b) p_result) -> ('a, 'b) p_result
  end

(**
The [p_func] type is the type signature for parser functions. Like [p_result], it 
takes in types ['a] and ['b] where ['a] is the type of the input and ['b] is the 
type of the output.   
*)
type ('a, 'b) p_func = 'a -> ('a, 'b) p_result
