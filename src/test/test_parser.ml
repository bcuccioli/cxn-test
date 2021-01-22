open Lib.Ast
open Lib.Exceptions
open OUnit2

module Parse = Parsed_ast

let parse s =
  Parse.from (fun () -> Lexing.from_string s)

let test_parse_success _ =
  let result = parse
    "alias a 127.0.0.1 (u)\n\
    alias c 192.168.1.1\n\
    ping a -> c accept\n\
    ping b->d reject\n"
  in
  assert_equal
    [
      Alias ("a", "127.0.0.1", Some "u");
      Alias ("c", "192.168.1.1", None);
      Test (Ping, "a", "c", Accept);
      Test (Ping, "b", "d", Reject);
    ]
    result

let test_parse_trailing_comments_success _ =
  let result = parse
    "alias a 127.0.0.1 (u)# this is a comment\n\
    alias c 192.168.1.1 #comment2\n"
  in
  assert_equal
    [
      Alias ("a", "127.0.0.1", Some "u");
      Alias ("c", "192.168.1.1", None);
    ]
    result

let test_parse_whitespace_success _ =
  let result = parse
    "# full line comment\n\
    alias a 127.0.0.1 # this is a comment\n\
    # another comment\n\
    \n\
    alias c 192.168.1.1 (u) #comment2\n"
  in
  assert_equal
    [
      Alias ("a", "127.0.0.1", None);
      Alias ("c", "192.168.1.1", Some "u");
    ]
    result

let test_parse_bad_keyword_fail _ =
  let go = fun () -> parse
    "alias a b\n\
    aliaz c d\n\
    ping a -> c accept\n\
    ping b->d reject\n"
  in
  assert_raises
    (ParseError "syntax error: line 2")
    go

let test_parse_bad_command_fail _ =
  let go = fun () -> parse
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
