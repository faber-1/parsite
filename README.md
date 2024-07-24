# Parsite

Parsite is a micro tiny parser combinator library that I originally made for a language project (coming soon hopefully).

Right now this is just for fun. I wrote it in a day, and it is not meant to be used in a serious manner, however I do plan to develop this project more.

If you plan to use this, you can just clone the library somewhere and copy the folder into the lib directory of your dune project.

I'd also like to thank [this video](https://www.youtube.com/watch?v=RDalzi7mhdY) for the help and inspiration.

## Features

### Types

```ocaml
type 'a result = 
| Win of ('a * string)
| Lose of string

module ResultM = struct
  let return (x : 'a) : 'a result = 
    Win x 

  let (>>=) (m : 'a result) (f : 'a -> 'b result) : 'b result =
    match m with 
    | Win a -> f a  
    | Lose _ as l-> l
end
```
A `result` type is what a parser will return after running. It either returns a success `Win` of whatever type you decide to parse, or a `Lose` type with a string for an error message

There's also the `ResultM` monad which has a `return` function that wrapps its input in a `Win` constructor, and the bind (`>>=`) operator which applies a function to a `result` value if that value is a `Win` value.

```ocaml
type 'a parser = 
| Parser of (string -> ('a * string) result)

type 'a parser = 
| Parser of 'a

module ParserM = struct
  let return (x : 'a): 'a parser = Parser x 

  let (>>=) (m : 'a parser) (f : 'a -> 'b parser) : 'b parser = 
    match m with 
    | Parser a -> f a
end

```
A `parser` type wraps the function for parsing a given string. The parser type is important as pretty much every operator and function in this library will use this type. It's basically hyper function composition wrapped in a type... one might say for extra computation.........

~~(I don't think this parser is a monad)~~ I was recently made aware that the `parser` and `result` types are in fact monads. I now see the way.

The `return` function for `ParserM` wraps the return function in a `parser` type, and the bind (`>>=`) operator applies the function given to the inner function of the `parser` value.

Parser functions have to return `result` types. This will be very heplful in your own parsers `:)`

### Functions

```ocaml
val run : ('a -> 'b) Types.parser -> 'a -> 'b
```

Takes a parser type value and runs it on a string. Returns the result of the computation. 

---
```ocaml
val ( /> ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> (('b * 'd) * 'e) Types.result) Types.parser
```

Infix concat operator. Concatenates two parsers, and creates a new parser that contains the two parser requirements in a tuple. I'd recommend performing extra operations on a tuple parser.

---
```ocaml
val ( >/ ) :
  ('a -> 'b Types.result) Types.parser ->
  ('a -> 'b Types.result) Types.parser ->
  ('a -> 'b Types.result) Types.parser
```

Infix or operator. Creates a parser that accepts either the input from the first or second parser passed in.

---
```ocaml
val ( />/ ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('b -> 'd) -> ('a -> ('d * 'c) Types.result) Types.parser
```

Infix map operator. Takes a parser and a function and applies it to the parser given. It returns a parser with a function applied to the original requirement.

---
```ocaml
val ( @> ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> ('d * 'e) Types.result) Types.parser
```

Infix ignore left operator. Takes two parsers and runs them both, but only keeps the result of the right side parser and discards the left.

---
```ocaml
val ( >@ ) :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('a -> ('b * 'e) Types.result) Types.parser
```

Infix ignore right operator. Takes two parsers, runs them, and keeps the result of the left side parser and discards the right.

---
```ocaml
val p_middle :
  ('a -> ('b * 'c) Types.result) Types.parser ->
  ('c -> ('d * 'e) Types.result) Types.parser ->
  ('e -> ('f * 'g) Types.result) Types.parser ->
  ('a -> ('d * 'g) Types.result) Types.parser
```

Takes 3 parsers, runs them all, but only keeps the middle parser's result.

---
```ocaml
val p_char : char -> (string -> (char * string) Types.result) Types.parser
```

Parses a single charcter.

---
```ocaml
val p_list :
  ('a -> ('b * 'a) Types.result) Types.parser list ->
  ('a -> ('b list * 'a) Types.result) Types.parser
  ```

Takes a list of parsers, and builds a list of those rules and puts that list in one parser.

---
```ocaml
val p_either :
  ('a -> 'b Types.result) Types.parser list ->
  ('a -> 'b Types.result) Types.parser
```

Takes a list of parsers, and accepts inputs for matches for any parser in the list.

---
```ocaml
val p_string :
  string -> (string -> (string * string) Types.result) Types.parser
```

Creates parser for a specific string.

---
```ocaml
val p_concat_str :
  ('a -> (string * 'b) Types.result) Types.parser ->
  ('b -> (string * 'c) Types.result) Types.parser ->
  ('a -> (string * 'c) Types.result) Types.parser
```

Concats two string parsers together.

---
```ocaml
val p_concat_strs :
  ('a -> (string * 'a) Types.result) Types.parser list ->
  ('a -> (string * 'a) Types.result) Types.parser  
```

Concats multiple string parsers together.

---
```ocaml
val p_char_as_str :
  char -> (string -> (string * string) Types.result) Types.parser
```

Takes a character and creates a string parser just for that character.

---
```ocaml
val p_many :
  ('a -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'a) Types.result) Types.parser
```

Matches given string parser 0 or more times. Like `*` from regex.

---
```ocaml
val p_many1 :
  ('a -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'a) Types.result) Types.parser
```

Matches given string parser 1 or more times. Like `+` from regex.

---
```ocaml
val p_lister :
  ('a -> (string * 'b) Types.result) Types.parser list ->
  ('b -> (string * 'a) Types.result) Types.parser ->
  ('a -> (string * 'b) Types.result) Types.parser
```

Takes a list of parsers and a delimiter, and creates a parser with the delimiter between each string in the list.

---
```ocaml
val p_lower : (string -> (string * string) Types.result) Types.parser
```

Matches lowercase letters.

---
```ocaml
val p_upper : (string -> (string * string) Types.result) Types.parser
```

Matches uppercase letters.

---
```ocaml
val p_digits : (string -> (string * string) Types.result) Types.parser
```

Matches digits.

### Errors

This library only has an `EmptyList` error. It gets raised whenever a function that takes in a list receives an empty list. 