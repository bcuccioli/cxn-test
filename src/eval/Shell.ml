open Cmd

module Impl = struct

  let host_str (test: Ast.test) = match test.usr with
    | Some u -> u ^ "@" ^ test.src
    | None -> test.src

  let cmd_str = function
    | Ping -> fun h -> Some ("ping -c 1 " ^ h)
    | Dns -> fun h -> Some ("dig google.com @" ^ h)
    | Ssh -> fun _ -> None

  let wrapped_cmd_str = function
    | Some s -> Printf.sprintf "'%s'" s
    | None -> ""
end

let cmd test =
  Printf.sprintf
    "ssh -o ConnectTimeout=10 %s %s"
    (Impl.host_str test)
    (Impl.wrapped_cmd_str ((Impl.cmd_str test.cmd) test.dst))
