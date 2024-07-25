(* Parsite functions, courtesy of faber-1 *)

(* thrown whenever functions that take lists take empty inputs *)
exception EmptyList of string

(* Infix concat operator. Concatenates two parsers, and creates a new parser 
   that contains the two parser requirements in a tuple. I'd recommend 
   performing extra operations on a tuple-returning parser.  *)
val ( /> ) :
  ('a, 'b) Types.p_func ->
  ('a, 'c) Types.p_func -> ('a, 'b * 'c) Types.p_func

(* Infix or operator. Creates a parser that accepts either the input from the 
   first or second parser passed in. *)
val ( >/ ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(* Infix map operator. Takes a parser and a function and applies it to the
   parser given. It returns a parser with a function applied to the original 
   requirement *)
val ( />/ ) : ('a, 'b) Types.p_func -> ('b -> 'c) -> ('a, 'c) Types.p_func

(* Infix ignore left operator. Takes two parsers and runs them both, but only 
   keeps the result of the right side parser and discards the left. *)
val ( @> ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(* Infix ignore right operator. Takes two parsers, runs them, and keeps the 
   result of the left side parser and discards the right. *)
val ( >@ ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(* Takes 3 parsers, runs them all, but only keeps the middle parser's result. *)
val p_middle :
  ('a, 'b) Types.p_func ->
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(* Parses a single charcter. *)
val p_char : char -> (string, char) Types.p_func

(* Takes a list of parsers, and creates a parser that returns a 'b list type of 
   the output of the original parser list. Essentially takes the parsers and
   creates one parser that lists them all. *)
val p_list : ('a, 'b) Types.p_func list -> ('a, 'b list) Types.p_func

(* Takes a list of parsers, and accepts inputs for matches for any parser in 
   the list.*)
val p_either : ('a, 'b) Types.p_func list -> ('a, 'b) Types.p_func

(* Creates parser for a specific string. *)
val p_string : string -> (string, string) Types.p_func

(* Concats two string parsers together. *)
val p_concat_str :
  (string, string) Types.p_func ->
  (string, string) Types.p_func -> (string, string) Types.p_func

(* Concats multiple string parsers together.*)
val p_concat_strs :
  (string, string) Types.p_func list -> (string, string) Types.p_func

(* Parses single character as a string *)
val p_char_as_str : char -> (string, string) Types.p_func

(* Takes string parser, matches it 0 or more times. Like * in regex. *)
val p_many : (string, string) Types.p_func -> (string, string) Types.p_func

(* Takes string parser, matches it 1 or more times. Like * in regex. *)
val p_many1 : (string, string) Types.p_func -> (string, string) Types.p_func

(* Takes a list of parsers and a delimiter, and creates a parser with the 
   delimiter between each string in the list. *)
val p_lister :
  (string, string) Types.p_func list ->
  (string, string) Types.p_func -> (string, string) Types.p_func

(* Matches lowercase letters *)
val p_lower : (string, string) Types.p_func

(* Matches uppercase letters *)
val p_upper : (string, string) Types.p_func

(* Matches digits *)
val p_digits : (string, string) Types.p_func

