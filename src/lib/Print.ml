open Ast
open Cmd
open Printf

let user_str = function
  | Some u -> sprintf "(%s)" u
  | None -> ""

let cmd = function
  | Ping -> "ping"
  | Ssh -> "ssh"
  | Dns -> "dns"

let result = function
  | Accept -> "ACCEPT"
  | Reject -> "REJECT"

let test t =
  sprintf "%s:\t%s\t->\t%s\t%s" (cmd t.cmd) t.src t.dst (user_str t.usr)
