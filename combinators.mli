type 'a result = Win of 'a | Lose of string
type 'a parser = Parser of (string -> ('a * string) result)
val run : 'a parser -> string -> ('a * string) result
val ( /> ) : 'a parser -> 'b parser -> ('a * 'b) parser
val ( >/ ) : 'a parser -> 'a parser -> 'a parser
val ( />/ ) : 'a parser -> ('a -> 'b) -> 'b parser
val ( @> ) : 'a parser -> 'b parser -> 'b parser
val ( >@ ) : 'a parser -> 'b parser -> 'a parser
val p_middle : 'a parser -> 'b parser -> 'c parser -> 'b parser
val p_char : char -> char parser
val p_list : 'a parser list -> 'a list parser
val p_either : 'a parser list -> 'a parser
val p_string : string -> string parser
val p_concat_str : string parser -> string parser -> string parser
val p_char_as_str : char -> string parser
val p_many : string parser -> string parser
val p_lister : string parser list -> string parser -> string parser
val p_lower : string parser
val p_upper : string parser
val p_digits : string parser