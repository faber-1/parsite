(*
Parsington

This small library mostly provides some simple parsing functions that you can
grow as you wish. 

This is a (hopefully continuous project. I shall add more to this as I find more 
cool parsing things to add.

This library is very string focused. A lot of functions return results with 
strings, but the result and parser types are provided for custom tinkering. 
Also, the infix ops are a bit more flexible. 

happy parsing!
*)

exception EmptyList of string

(* Result, can be used to parse  *)
type 'a result = 
| Win of 'a
| Lose of string

type 'a parser = 
| Parser of (string -> ('a * string) result)

let run par inp = 
  let (Parser fn) = par in 
  fn inp
;;

let reduce f lst = 
  match lst with 
  | [] -> None
  | h::t -> Some (List.fold_left f h t)
;;

(* the fact String doesn't have an explode function is sad. *)
let explode s = List.init (String.length s) (String.get s)

(* And binder *)
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

(* Or binder *)
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

(* Map binder *)
let ( />/ ) p1 f = 
  let mapped str = 
    match run p1 str with 
    | Win (a, str') -> 
      Win (f a, str')
    | Lose a -> Lose a 
  in Parser mapped
;;

(* Parse and ignore left *)
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


(* Parse and ignore right *)
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

let p_concat_str p1 p2 = 
  p1 /> p2 />/ (fun (x,y) -> x ^ y)
;;

let p_char_as_str ch = 
  p_string (String.make 1 ch)
;;

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

let rec p_lister ps delim = 
  match ps with 
  | [] -> raise (EmptyList "p_lister cannot be called with an empty ps")
  | [e] -> e
  | p::ps -> p_concat_str (p_concat_str p delim) (p_lister ps delim)
;;

let p_lower = p_either (List.map p_char_as_str (explode "abcdefghijklmnopqrstuvwxyz"))
let p_upper = p_either (List.map p_char_as_str (explode "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))
let p_digits = p_either (List.map p_char_as_str (explode "0123456789"))