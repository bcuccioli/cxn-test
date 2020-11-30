open Ast
open Cmd
open Exceptions
open OUnit2

let test_bind_success _ =
  let stmts = [
    Alias ("a", "x");
    Alias ("b", "y");
    Test (Ping, "a", "b", Accept);
    Test (Ssh, "x", "z", Reject);
  ] in
  let bound = [
    {
      cmd = Ping;
      src = "x";
      dst = "y";
      res = Accept;
    };
    {
      cmd = Ssh;
      src = "x";
      dst = "z";
      res = Reject;
    };
  ] in
  assert_equal bound (bind stmts)

let test_bind_sequential_success _ =
  let stmts = [
    Alias ("a", "x");
    Alias ("b", "y");
    Test (Ping, "a", "b", Accept);
    Test (Ping, "c", "d", Reject);
    Alias ("c", "z");
    Test (Ping, "c", "d", Reject);
  ] in
  let bound = [
    {
      cmd = Ping;
      src = "x";
      dst = "y";
      res = Accept;
    };
    {
      cmd = Ping;
      src = "c";
      dst = "d";
      res = Reject;
    };
    {
      cmd = Ping;
      src = "z";
      dst = "d";
      res = Reject;
    };
  ] in
  assert_equal bound (bind stmts)

let test_bind_shadow_fail _ =
  let stmts = [
    Alias ("a", "x");
    Alias ("b", "y");
    Test (Ping, "a", "b", Accept);
    Alias ("a", "z");
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
