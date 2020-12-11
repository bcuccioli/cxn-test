open Exceptions

type cmd =
  | Ping
  | Ssh
  | Dns

let parse = function
  | "ping" -> Ping
  | "ssh" -> Ssh
  | "dns" -> Dns
  | s -> raise (CmdError ("Unrecognized command: " ^ s))
