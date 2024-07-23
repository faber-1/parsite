(*
Parsite

This small library mostly provides some simple parsing functions that you can
grow as you wish. 

This is a (hopefully continuous project. I shall add more to this as I find more 
cool parsing things to add.

This library is very string focused. A lot of functions return results with 
strings, but the result and parser types are provided for custom tinkering. 
Also, the infix ops are a bit more flexible. 

Also this library raises errors. Can't decide if that makes the functions impure
but I may try to fix the functions up later.

happy parsing!
*)

exception EmptyList of string

(* Result type, used as parser output. Essentially either, but left type takes a 
   string. *)
type 'a result = 
| Win of 'a
| Lose of string

(* Parser type, wraps parsing function that takes a string and returns a result
   type with a 2-tuple parameter of ('a * string). The 'a type can be an accumulator
   for parsers that don't accumulate strings. *)
type 'a parser = 
| Parser of (string -> ('a * string) result)

(* unwraps parser type in par and runs parser on input string inp *)
let run par inp = 
  let (Parser fn) = par in 
  fn inp
;;

(* inner reduce function for some shenanigans *)
let reduce f lst = 
  match lst with 
  | [] -> None
  | h::t -> Some (List.fold_left f h t)
;;

(* the fact String doesn't have an explode function is sad. *)
let explode s = List.init (String.length s) (String.get s)

(* And binder, returns parser that concats p1 and p2. The return type value of the
   returned parser will have a tuple of the concatenated matches. *)
let ( /> ) p1 p2 = 
  let binded str = 
    match run p1 str with 
    | Win (a, str') -> 
      (match run p2 str' with 
      | Win (a', str'') ->
        Win ((a, a'), str'')
      | Lose a -> Lose a
      ) 
    | Lose a -> Lose a
  in Parser binded
;;

(* Or binder, will return parser for first match between p1 and p2 *)
let ( >/ ) p1 p2 = 
  let ored str = 
    match run p1 str with 
    | Win (a, str') -> 
      Win (a, str') 
    | Lose _ -> 
      match run p2 str with 
      | Win (a', str') -> Win (a', str')
      | Lose a' -> Lose a'
  in Parser ored
;;

(* Map binder, binds function f to parser output *)
let ( />/ ) p1 f = 
  let mapped str = 
    match run p1 str with 
    | Win (a, str') -> 
      Win (f a, str')
    | Lose a -> Lose a 
  in Parser mapped
;;

(* Parse and ignore left of operator *)
let ( @> ) p1 p2 = 
  let igleft str = 
    match run p1 str with 
    | Win (_, str') -> 
      (match run p2 str' with 
      | Win (a, str'') -> Win (a, str'')
      | Lose a -> Lose a
      )
    | Lose a -> Lose a
  in 
  Parser igleft
;;


(* Parse and ignore right of operator *)
let ( >@ ) p1 p2 = 
  let igright str = 
    match run p1 str with 
    | Win (a, str') -> 
      (match run p2 str' with 
      | Win (_, str'') -> Win(a, str'')
      | Lose a -> Lose a
      )
    | Lose a -> Lose a
  in
  Parser igright
;;

(* Parse middle p2 without parsing p1 and p3 *)
let p_middle p1 p2 p3 = 
  p1 @> p2 >@ p3
;;

let p_char ch = 
  let parser str = 
    if str = "" then 
      Lose "Empty String"
    else
      let first, rest = String.get str 0, String.sub str 1 (String.length str - 1) in 
      if first = ch then 
        Win (ch, rest)
      else
        Lose (Printf.sprintf "Expected char '%c', got char '%c'" ch first)  
  in
  Parser parser
;;

(* Takes a list of parsers lst, and creates a parser that contains the list of rules for each parser passed in *)
let p_list lst = 
  let concat p1 p2 = 
    p1 /> p2 />/ (fun (x,y) -> x @ y)
  in 
  let ps =  
    lst |>
    List.map (fun a -> a />/ (fun e -> [e])) |>
    reduce concat
  in
  match ps with 
  | Some p -> p 
  | None -> raise (EmptyList "p_list cannot be called with empty list")
;;

let p_either lst = 
  match reduce (>/) lst with
  | Some a -> a 
  | None -> raise (EmptyList "p_either cannot be called with empty list") 
;;

(* Creates parser for string str *)
let p_string str = 
  let p_inner = 
    (str |> 
    explode |> 
    List.map p_char |> 
    p_list )
    />/ (fun a -> String.of_seq (List.to_seq a))
  in 
  Parser (fun a -> 
    match run p_inner a with 
    | Win (a, str) -> Win (a, str)
    | Lose _ -> Lose (Printf.sprintf "Expected string '%s', got '%s'" str a))
;;

(* Creates parser for string of p1 concatted to string of p2 *)
let p_concat_str p1 p2 = 
  p1 /> p2 />/ (fun (x,y) -> x ^ y)
;;

(* Creates parser from concatenated strings in list *)
let p_concat_strs ps = reduce p_concat_str ps ;;

(* Creates parser for character as a string *)
let p_char_as_str ch = 
  p_string (String.make 1 ch)
;;

(* Creates parser for 0 or more matches of p *)
let p_many p = 
  let rec inner acc str = 
    match run p str with 
    | Win (a, str') -> 
      inner (acc ^ a) str' 
    | Lose _ -> 
      Win (acc, str)
  in
  Parser (inner "") 
;;

(* Creates parser for 1 or more matches of p *)
let p_many1 p = 
  p_concat_str p (p_many p)
;;

(* Takes parsers list and delimiter, creates parser with delim in between parsers in ps *)
let rec p_lister ps delim = 
  match ps with 
  | [] -> raise (EmptyList "p_lister cannot be called with an empty ps")
  | [e] -> e
  | p::ps -> p_concat_str (p_concat_str p delim) (p_lister ps delim)
;;


(* lowercase, uppercase, and digits parsers *)
let p_lower = p_either (List.map p_char_as_str (explode "abcdefghijklmnopqrstuvwxyz"))
let p_upper = p_either (List.map p_char_as_str (explode "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))
let p_digits = p_either (List.map p_char_as_str (explode "0123456789"))