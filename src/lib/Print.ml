open Ast
open Cmd
open Printf

module Impl = struct

  let user_str = function
    | Some u -> sprintf "(%s)" u
    | None -> ""

end

let cmd = function
  | Ping -> "ping"
  | Ssh -> "ssh"
  | Dns -> "dns"

let result = function
  | Accept -> "ACCEPT"
  | Reject -> "REJECT"

let test t =
  sprintf "%s:\t%s\t->\t%s\t%s"
    (cmd t.cmd)
    t.src
    t.dst
    (Impl.user_str t.usr)
