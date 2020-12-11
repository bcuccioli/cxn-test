open Cmd

module Impl = struct
  let host_str (test : Ast.test) =
    match test.usr with
      | Some u -> u ^ "@" ^ test.src
      | None -> test.src

  let cmd_str h = function
    | Ping -> "ping -c 1 " ^ h
    | Dns -> "nslookup google.com " ^ h
    | Ssh -> "netcat -nzv " ^ h ^ " 22"
end

let cmd test =
  Printf.sprintf "ssh -o ConnectTimeout=10 %s '%s'" (Impl.host_str test)
    (Impl.cmd_str test.dst test.cmd)
