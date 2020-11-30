open Ast
open Exceptions
open OUnit2
open Parse

let test_parse_success _ =
  let result = Parse.from_string
    "alias a b (u)\n\
    alias c d\n\
    ping a -> c accept\n\
    ping b->d reject\n"
  in
  assert_equal
    [
      Alias ("a", "b", Some "u");
      Alias ("c", "d", None);
      Test (Ping, "a", "c", Accept);
      Test (Ping, "b", "d", Reject);
    ]
    result

let test_parse_trailing_comments_success _ =
  let result = Parse.from_string
    "alias a b (u)# this is a comment\n\
    alias c d #comment2\n"
  in
  assert_equal
    [
      Alias ("a", "b", Some "u");
      Alias ("c", "d", None);
    ]
    result

let test_parse_whitespace_success _ =
  let result = Parse.from_string
    "# full line comment\n\
    alias a b # this is a comment\n\
    # another comment\n\
    \n\
    alias c d (u) #comment2\n"
  in
  assert_equal
    [
      Alias ("a", "b", None);
      Alias ("c", "d", Some "u");
    ]
    result

let test_parse_bad_keyword_fail _ =
  let go = fun () -> Parse.from_string
    "alias a b\n\
    aliaz c d\n\
    ping a -> c accept\n\
    ping b->d reject\n"
  in
  assert_raises
    (ParseError "syntax error: line 2")
    go

let test_parse_bad_command_fail _ =
  let go = fun () -> Parse.from_string
    "alias a b\n\
    alias c d\n\
    sshx a -> c accept\n"
  in
  assert_raises
    (ParseError "Unrecognized command: sshx: line 4")
    go

let suite =
  "ParserTests" >::: [
    "test_parse_success" >:: test_parse_success;
    "test_parse_trailing_comments_success" >:: test_parse_trailing_comments_success;
    "test_parse_whitespace_success" >:: test_parse_whitespace_success;
    "test_parse_bad_keyword_fail" >:: test_parse_bad_keyword_fail;
    "test_parse_bad_command_fail" >:: test_parse_bad_command_fail;
  ]


let () =
  run_test_tt_main suite
