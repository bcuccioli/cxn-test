open Printf

let user_str = function
  | Some u -> sprintf "(%s)" u
  | None -> ""

let cmd = function
  | Cmd.Ping -> "ping"
  | Cmd.Ssh -> "ssh"
  | Cmd.Dns -> "dns"

let result = function
  | Ast.Accept -> "ACCEPT"
  | Ast.Reject -> "REJECT"

let test (t: Ast.test) =
  sprintf "%s:\t%s\t->\t%s\t%s" (cmd t.cmd) t.src t.dst (user_str t.usr)
