(** Parsite functions, courtesy of faber-1 *)

(** NOTE ON FUNCTIONS THAT TAKE PARSERS AS INPUT: 
    Lose messages are propagated from input parsers unless stated otherwise. *)

(** Thrown whenever functions that take parser lists take empty inputs *)
exception EmptyList of string

(** Infix concat operator. Concatenates two parsers and creates a new parser 
    that contains the two parser requirements in a tuple. I'd recommend 
    performing extra operations on a tuple-returning parser.  

    Example of Win: 

    {[
      let p1 = p_string "hi" in
      let p2 = p_string "hello" in 
      
      let pfin = p1 /> p2 in 

      pfin "hihello" = Win (("hi", "hello"), "")
    ]}
   
   *)
val ( /> ) :
  ('a, 'b) Types.p_func ->
  ('a, 'c) Types.p_func -> ('a, 'b * 'c) Types.p_func

(** Infix or operator. Creates a parser that accepts either the input from the 
    first or second parser passed in. 

    Example of Win:
    {[
      let p1 = p_char 'a' in 
      let p2 = p_char 'b' in 

      let pfin = p1 >/ p2 in 

      (pfin "ae" = Win ('a', "e")) && (pfin "be" = Win ('b', "e"))
    ]}

    Example of Lose:
    {[
      let p1 = p_char 'a' in 
      let p2 = p_char 'b' in 

      let pfin = p1 >/ p2 in 

      (pfin "wa" = Lose "Or Problem: Failed with following errors: (Expected char 'a', got char 'w') and (Expected char 'b', got char 'w')" )
    ]}

    Lose message spits out Lose messages of both inputs
   *)
val ( >/ ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(** Infix map operator. Takes a parser and a function and applies it to the
    parser's output. It returns a parser with a function applied to the original 
    requirement match
    
    Example:
    {[
      let p = p_string "hi" in 
      let f = fun x -> "H" ^ x in 

      let pfin = p />/ f in 

      pfin "hi aa" = Win ("Hhi", " aa")
    ]}
    
    NOTE: The function is applied to the parser's *output*. The function is not 
    applying anything to the input of the parser.
    *)
val ( />/ ) : ('a, 'b) Types.p_func -> ('b -> 'c) -> ('a, 'c) Types.p_func

(** Infix ignore left operator. Takes two parsers and runs them both, but only 
    keeps the result of the right side parser and discards the left. 
    
    Example:
    {[
      let p1 = p_string "ignore" in
      let p2 = p_string "keep" in

      let pfin = p1 @> p2 in 

      pfin "ignorekeeprest" = Win ("keep", "rest")
   ]}*)
val ( @> ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(** Infix ignore right operator. Takes two parsers, runs them, and keeps the 
    result of the left side parser and discards the right. 
    
    Example:
    {[
      let p1 = p_string "keep" in
      let p2 = p_string "ignore" in

      let pfin = p1 >@ p2 in 

      pfin "keepignorerest" = Win ("keep", "rest")
    ]}*)
val ( >@ ) :
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(** Takes 3 parsers, runs them all, but only keeps the middle parser's result. 
    
    Example:
    {[
      let p1 = p_string "i1" in
      let p2 = p_string "keep" in
      let p3 = p_string "i2" in 

      let pfin = p_middle p1 p2 p3 in 

      pfin "i1keepi2rest" = Win ("keep", "rest")
    ]}*)
val p_middle :
  ('a, 'b) Types.p_func ->
  ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func -> ('a, 'b) Types.p_func

(** Parses a single charcter. 

    Lose messages are either of form ["Empty String"] or ["Expected char '%c', got char '%c'"].
    
    Example:
    {[
      let pa = p_char 'a' in 

      pa "abc" = Win ('a', "bc")
    ]}*)
val p_char : char -> (string, char) Types.p_func

(** Takes a list of parsers, and creates a parser that parses into a 'b list type 
    of the output of the original parser list. Essentially takes the parsers and
    creates one parser that concats them all.
    
    Example:

    {[
      let ps = ['a'; 'b'; 'c'] |> List.map p_char in 

      let pfin = p_list ps in 

      pfin "abcde" = Win (['a'; 'b'; 'c'], "de")
    ]}
    *)
val p_list : ('a, 'b) Types.p_func list -> ('a, 'b list) Types.p_func

(** Takes a list of parsers, and accepts inputs for matches for any parser in 
    the list.
    
    Example:
    {[
      let pfin = ['1'; '2'; '3'] |> List.map p_char |> p_either in 
      
      (pfin "1rest" = Win ('1', "rest")) &&
      (pfin "2rest" = Win ('2', "rest")) && 
      (pfin "3rest" = Win ('3', "rest"))
   ]}*)
val p_either : ('a, 'b) Types.p_func list -> ('a, 'b) Types.p_func

(** Creates parser for a specific string. 

    Lose message is of form ["Expected string '%s', got '%s'"]
      
    Example: 
    {[
      let p1 = p_string "hey" in 

      p1 "heyhi" = Win ("hey", "hi")
    ]}*)
val p_string : string -> (string, string) Types.p_func

(** Concats two string parsers together. 
    
    Example:
    {[
      let p1 = p_string "time" in
      let p2 = p_string "zone" in 

      let p_fin = p_concat_str p1 p2 in 

      p_fin "timezone difference" = Win("timezone", " difference") 
    ]}*)
val p_concat_str :
  (string, string) Types.p_func ->
  (string, string) Types.p_func -> (string, string) Types.p_func

(** Concats multiple string parsers together.
    
    Example:
    {[
      let pfin = ["he"; "ha"; "ts"] |> List.map p_string |> p_concat_strs in 

      pfin "hehatsthehat" = Win ("hehats", "thehat")
    ]}*)
val p_concat_strs :
  (string, string) Types.p_func list -> (string, string) Types.p_func

(** Parses single character as a string 
    
    Example:
    {[
      let pa = p_char_as_str 'a' in 

      pa "abc" = Win ("a", "bc")
    ]}*)
val p_char_as_str : char -> (string, string) Types.p_func

(** Takes string parser, matches it 0 or more times. Like * in regex. 
    
    Example: 
    {[
      let p = p_string "he" in 

      let pfin = p_many p in 

      (pfin ".." = Win ("", "..")) &&
      (pfin "he.." = Win ("he", "..")) && 
      (pfin "hehehehehehehehehehehe" = Win ("hehehehehehehehehehehe", ""))

    ]}*)
val p_many : (string, string) Types.p_func -> (string, string) Types.p_func

(** Takes string parser, matches it 1 or more times. Like + in regex. 
    
    Example: 
    {[
      let p = p_string "he" in 
      
      let pfin = p_many1 p in 

      (pfin ".." = Lose "Expected string 'he', got '..'") &&
      (pfin "he" = Win ("he", "")) && 
      (pfin "hehehehehehehehehehehe" = Win ("hehehehehehehehehehehe", ""))
    ]}*)
val p_many1 : (string, string) Types.p_func -> (string, string) Types.p_func

(** Takes a list of parsers and a delimiter, and creates a parser with the 
   delimiter between each string in the list. 
   
   Example: 
   {[
    let ps = ["one"; "two"; "three"] |> List.map p_string in 
    let p = ["single"] |> List.map p_string in
    let delim = p_string "," in 

    let ps' = p_lister ps delim in 
    let p' = p_lister p delim in 

    (ps' "one,two,threerest" = Win ("one,two,three", "rest")) && 
    (p' "singlerest" = Win ("single", "rest"))

   ]}*)
val p_lister :
  (string, string) Types.p_func list ->
  (string, string) Types.p_func -> (string, string) Types.p_func

(** Matches lowercase letters *)
val p_lower : (string, string) Types.p_func

(** Matches uppercase letters *)
val p_upper : (string, string) Types.p_func

(** Matches digits *)
val p_digits : (string, string) Types.p_func

