open Exceptions

type cmd =
  | Ping
  | Ssh
  | Dns

let parse = function
  | "ping" -> Ping
  | "ssh" -> Ssh
  | "dns" -> Dns
  | _ -> raise (Detail.CmdError ("Unrecognized command: " ^ s))
