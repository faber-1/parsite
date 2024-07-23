# Parsite

Parsite is a micro tiny library that I originally made for a language project (coming soon hopefully).

Right now this is just for fun. It is not meant to be used in a serious manner, however I do plan to develop this page more.



## Features

### Types

```ocaml
type 'a result = 
| Win of ('a * string)
| Lose of string
```
A `result` type is what a parser will return after running. It either returns a success `Win` of whatever type you decide to parse, or a `Lose` type with a string for an error message

```ocaml
type 'a parser = 
| Parser of (string -> ('a * string) result)
```
A `parser` type wraps the function for parsing a given string. The parser type is important as pretty much every operator and function in this library will use this type. It's basically hyper function composition wrapped in a type... one might say for extra computation.........

(I don't think this parser is a monad)

Parser functions have to return `result` types. This will be very heplful in your own parsers `:)`

### Functions

```ocaml
val run : 'a parser -> string -> ('a * string) result
```

Takes a parser type value and runs it on a string. Returns the result of the computation. 

---
```ocaml
val ( /> ) : 'a parser -> 'b parser -> ('a * 'b) parser
```

Infix concat operator. Concatenates two parsers, and creates a new parser that contains the two parser requirements in a tuple. I'd recommend performing extra operations on a tuple parser.

---
```ocaml
val ( >/ ) : 'a parser -> 'a parser -> 'a parser
```

Infix or operator. Creates a parser that accepts either the input from the first or second parser passed in.

---
```ocaml
val ( />/ ) : 'a parser -> ('a -> 'b) -> 'b parser
```

Infix map operator. Takes a parser and a function and applies it to the parser given. It returns a parser with a function applied to the original requirement.

---
```ocaml
val ( @> ) : 'a parser -> 'b parser -> 'b parser
```

Infix ignore left operator. Takes two parsers and runs them both, but only keeps the result of the right side parser and discards the left.

---
```ocaml
val ( >@ ) : 'a parser -> 'b parser -> 'a parser
```

Infix ignore right operator. Takes two parsers, runs them, and keeps the result of the left side parser and discards the right.

---
```ocaml
val p_middle : 'a parser -> 'b parser -> 'c parser -> 'b parser
```

Takes 3 parsers, runs them all, but only keeps the middle parser's result.

---
```ocaml
val p_char : char -> char parser
```

Parses a single charcter.

---
```ocaml
val p_list : 'a parser list -> 'a list parser
```

Takes a list of parsers, and builds a list of those rules and puts that list in one parser.

---
```ocaml
val p_either : 'a parser list -> 'a parser
```

Takes a list of parsers, and accepts inputs for matches for any parser in the list.

---
```ocaml
val p_string : string -> string parser
```

Creates parser for a specific string.

---
```ocaml
val p_concat_str : string parser -> string parser -> string parser
```

Concats two string parsers together.

---
```ocaml
val p_concat_strs : string parser list -> string parser 
```

Concats multiple string parsers together.

---
```ocaml
val p_char_as_str : char -> string parser
```

Takes a character and creates a string parser just for that character.

---
```ocaml
val p_many : string parser -> string parser
```

Matches given string parser 0 or more times. Like `*` from regex.

---
```ocaml
val p_many1 : string parser -> string parser
```

Matches given string parser 1 or more times. Like `+` from regex.

---
```ocaml
val p_lister : string parser list -> string parser -> string parser
```

Takes a list of parsers and a delimiter, and creates a parser with the delimiter between each string in the list.

---
```ocaml
val p_lower : string parser
```

Matches lowercase letters.

---
```ocaml
val p_upper : string parser
```

Matches uppercase letters.

---
```ocaml
val p_digits : string parser
```

Matches digits.