open Lib

let host_str (test : Ast.test) =
  match test.usr with
    | Some u -> u ^ "@" ^ test.src
    | None -> test.src

let cmd_str h = function
  | Cmd.Ping -> "ping -c 1 " ^ h
  | Cmd.Dns -> "nslookup google.com " ^ h
  | Cmd.Ssh -> "netcat -nzv " ^ h ^ " 22"

let cmd test =
  Printf.sprintf "ssh -o ConnectTimeout=10 %s '%s'" (host_str test)
    (cmd_str test.dst test.cmd)
