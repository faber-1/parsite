open OUnit2
open Parsite.Combinators

let tests = "tests for parsite" >::: [
  "test ( /> )" >:: (fun _ -> 
    assert_bool "Failed ( /> )"
      (let p1 = p_string "hi" in
      let p2 = p_string "hello" in 
      
      let pfin = p1 /> p2 in 

      pfin "hihello" = Win (("hi", "hello"), "")));
  
  "test ( >/ )" >:: (fun _ -> 
    assert_bool "Failed ( >/ ) win check"
      (let p1 = p_char 'a' in 
      let p2 = p_char 'b' in 

      let pfin = p1 >/ p2 in 

      (pfin "ae" = Win ('a', "e")) && (pfin "be" = Win ('b', "e")));
    assert_bool "Failed ( >/ ) lose check" 
      (let p1 = p_char 'a' in 
      let p2 = p_char 'b' in 

      let pfin = p1 >/ p2 in 

      (pfin "wa" = Lose "Or Problem: Failed with following errors: (Expected char 'a', got char 'w') and (Expected char 'b', got char 'w')" )));

  "test ( />/ )" >:: (fun _ -> 
    assert_bool "Failed ( />/ )" 
      (let p = p_string "hi" in 
      let f = fun x -> "H" ^ x in 

      let pfin = p />/ f in 

      pfin "hi aa" = Win ("Hhi", " aa")));

  "test ( @> )" >:: (fun _ -> 
    assert_bool "Failed ( @> )"
      (let p1 = p_string "ignore" in
      let p2 = p_string "keep" in

      let pfin = p1 @> p2 in 

      pfin "ignorekeeprest" = Win ("keep", "rest")));
    
  "test ( >@ )" >:: (fun _ -> 
    assert_bool "Failed ( >@ )"
      (let p1 = p_string "keep" in
      let p2 = p_string "ignore" in

      let pfin = p1 >@ p2 in 

      pfin "keepignorerest" = Win ("keep", "rest")));

  "test p_middle" >:: (fun _ -> 
    assert_bool "Failed p_middle" 
      (let p1 = p_string "i1" in
      let p2 = p_string "keep" in
      let p3 = p_string "i2" in 

      let pfin = p_middle p1 p2 p3 in 

      pfin "i1keepi2rest" = Win ("keep", "rest")));
  
  "test p_char" >:: (fun _ -> 
    assert_bool "Failed p_char"
      (let pa = p_char 'a' in 

      pa "abc" = Win ('a', "bc")));

  "test p_list" >:: (fun _ -> 
    assert_bool "Failed p_list"
      (let ps = ['a'; 'b'; 'c'] |> List.map p_char in 

      let pfin = p_list ps in 

      pfin "abcde" = Win (['a'; 'b'; 'c'], "de")));

  "test p_either" >:: (fun _ -> 
    assert_bool "Failed p_either"
      (let pfin = ['1'; '2'; '3'] |> List.map p_char |> p_either in 
      
      (pfin "1rest" = Win ('1', "rest")) &&
      (pfin "2rest" = Win ('2', "rest")) && 
      (pfin "3rest" = Win ('3', "rest"))));

  "test p_string" >:: (fun _ -> 
    assert_bool "Failed p_string"
      (let p1 = p_string "hey" in 

      p1 "heyhi" = Win ("hey", "hi")));

  "test p_concat_str" >:: (fun _ -> 
    assert_bool "Failed p_concat_str"
      (let p1 = p_string "time" in
      let p2 = p_string "zone" in 

      let p_fin = p_concat_str p1 p2 in 

      p_fin "timezone difference" = Win("timezone", " difference")));

  "test p_concat_strs" >:: (fun _ -> 
    assert_bool "Failed p_concat_strs"
      (let pfin = ["he"; "ha"; "ts"] |> List.map p_string |> p_concat_strs in 

      pfin "hehatsthehat" = Win ("hehats", "thehat")));

  "test p_char_as_str" >:: (fun _ -> 
    assert_bool "Failed p_char_as_str"
      (let pa = p_char_as_str 'a' in 

      pa "abc" = Win ("a", "bc")));

  "test p_many" >:: (fun _ -> 
    assert_bool "Failed p_many"
      (let p = p_string "he" in 

      let pfin = p_many p in 

      (pfin ".." = Win ("", "..")) &&
      (pfin "he.." = Win ("he", "..")) && 
      (pfin "hehehehehehehehehehehe" = Win ("hehehehehehehehehehehe", ""))));

  "test p_many1" >:: (fun _ -> 
    assert_bool "Failed p_many1"
      (let p = p_string "he" in 
      
      let pfin = p_many1 p in 

      (pfin ".." = Lose "Expected string 'he', got '..'") &&
      (pfin "he" = Win ("he", "")) && 
      (pfin "hehehehehehehehehehehe" = Win ("hehehehehehehehehehehe", ""))));

  "test p_lister" >:: (fun _ -> 
    assert_bool "Failed p_lister"
      (let ps = ["one"; "two"; "three"] |> List.map p_string in 
      let p = ["single"] |> List.map p_string in
      let delim = p_string "," in 
  
      let ps' = p_lister ps delim in 
      let p' = p_lister p delim in 
  
      (ps' "one,two,threerest" = Win ("one,two,three", "rest")) && 
      (p' "singlerest" = Win ("single", "rest"))));

]

let () = 
  run_test_tt_main tests