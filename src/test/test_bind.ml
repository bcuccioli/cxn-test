open Ast
open Cmd
open Exceptions
open OUnit2

let test_bind_success _ =
  let stmts = [
    Alias ("a", "x", Some "u");
    Alias ("b", "y", None);
    Test (Ping, "a", "b", Accept);
    Test (Ssh, "x", "z", Reject);
  ] in
  let bound = [
    {
      cmd = Ping;
      src = "x";
      dst = "y";
      res = Accept;
      usr = Some "u";
    };
    {
      cmd = Ssh;
      src = "x";
      dst = "z";
      res = Reject;
      usr = None;
    };
  ] in
  assert_equal bound (bind stmts)

let test_bind_sequential_success _ =
  let stmts = [
    Alias ("a", "x", Some "u");
    Alias ("b", "y", None);
    Test (Ping, "a", "b", Accept);
    Test (Ping, "c", "d", Reject);
    Alias ("c", "z", None);
    Test (Ping, "c", "d", Reject);
  ] in
  let bound = [
    {
      cmd = Ping;
      src = "x";
      dst = "y";
      res = Accept;
      usr = Some "u";
    };
    {
      cmd = Ping;
      src = "c";
      dst = "d";
      res = Reject;
      usr = None;
    };
    {
      cmd = Ping;
      src = "z";
      dst = "d";
      res = Reject;
      usr = None;
    };
  ] in
  assert_equal bound (bind stmts)

let test_bind_shadow_fail _ =
  let stmts = [
    Alias ("a", "x", None);
    Alias ("b", "y", None);
    Test (Ping, "a", "b", Accept);
    Alias ("a", "z", None);
  ] in
  assert_raises
    (ShadowError ("a", "z", "x"))
    (fun () -> bind stmts)

let suite =
  "BindTests" >::: [
    "test_bind_success" >:: test_bind_success;
    "test_bind_sequential_success" >:: test_bind_sequential_success;
    "test_bind_shadow_fail" >:: test_bind_shadow_fail;
  ]


let () =
  run_test_tt_main suite
