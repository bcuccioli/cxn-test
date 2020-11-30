open Ast
open Cmd
open OUnit2
open Shell

let test = {
  src = "127.0.0.1";
  dst = "192.168.1.1";
  usr = Some "me";
  cmd = Ping;
  res = Accept;
}

let case exp t =
  fun _ -> assert_equal exp (Shell.cmd t)

let suite = "ShellTests" >::: [
  "test_ping_user" >:: case
    "ssh -o ConnectTimeout=10 me@127.0.0.1 'ping -c 1 192.168.1.1'"
    { test with cmd=Ping };
  "test_ping" >:: case
    "ssh -o ConnectTimeout=10 127.0.0.1 'ping -c 1 192.168.1.1'"
    { test with cmd=Ping; usr=None };

  "test_ssh_user" >:: case
    "ssh -o ConnectTimeout=10 me@127.0.0.1 'nc -zv 192.168.1.1 22'"
    { test with cmd=Ssh };
  "test_ssh" >:: case
    "ssh -o ConnectTimeout=10 127.0.0.1 'nc -zv 192.168.1.1 22'"
    { test with cmd=Ssh; usr=None };

  "test_dns_user" >:: case
    "ssh -o ConnectTimeout=10 me@127.0.0.1 'dig google.com @192.168.1.1'"
    { test with cmd=Dns };
  "test_dns" >:: case
    "ssh -o ConnectTimeout=10 127.0.0.1 'dig google.com @192.168.1.1'"
    { test with cmd=Dns; usr=None };
]


let () =
  run_test_tt_main suite
