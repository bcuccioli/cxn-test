type cmd =
  | Ping
  | Ssh
  | Dns

let parse = function
  | "ping" -> Ping
  | "ssh" -> Ssh
  | "dns" -> Dns
  | s -> raise (Exceptions.CmdError ("Unrecognized command: " ^ s))
