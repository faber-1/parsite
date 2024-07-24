exception EmptyList of string
val run : ('a -> 'b) Types.parser -> 'a -> 'b
val ( /> ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> (('b * 'd) * 'e) Types.result) Types.parser
val ( >/ ) :
  ('a -> 'b Types.result) Types.parser ->
  ('a -> 'b Types.result) Types.parser ->
  ('a -> 'b Types.result) Types.parser
val ( />/ ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('b -> 'd) -> ('a -> ('d * 'c) Types.result) Types.parser
val ( @> ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> ('d * 'e) Types.result) Types.parser
val ( >@ ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> ('b * 'e) Types.result) Types.parser
val p_middle :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('e -> ('f * 'g) Types.result) Types.parser ->
  ('a -> ('d * 'g) Types.result) Types.parser
val p_char : char -> (string -> (char * string) Types.result) Types.parser
val p_list :
  ('a -> ('b * 'a) Types.result) Types.parser list ->
  ('a -> ('b list * 'a) Types.result) Types.parser
val p_either :
  ('a -> 'b Types.result) Types.parser list ->
  ('a -> 'b Types.result) Types.parser
val p_string :
  string -> (string -> (string * string) Types.result) Types.parser
val p_concat_str :
  ('a -> (string * 'b) Types.result) Types.parser ->
  ('b -> (string * 'c) Types.result) Types.parser ->
  ('a -> (string * 'c) Types.result) Types.parser
val p_concat_strs :
  ('a -> (string * 'a) Types.result) Types.parser list ->
  ('a -> (string * 'a) Types.result) Types.parser
val p_char_as_str :
  char -> (string -> (string * string) Types.result) Types.parser
val p_many :
  ('a -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'a) Types.result) Types.parser
val p_many1 :
  ('a -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'a) Types.result) Types.parser
val p_lister :
  ('a -> (string * 'b) Types.result) Types.parser list ->
  ('b -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'b) Types.result) Types.parser
val p_lower : (string -> (string * string) Types.result) Types.parser
val p_upper : (string -> (string * string) Types.result) Types.parser
val p_digits : (string -> (string * string) Types.result) Types.parser
