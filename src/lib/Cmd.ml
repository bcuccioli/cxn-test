open Exceptions

type cmd =
  | Ping
  | Ssh
  | Dns

let parse s = match s with
  | "ping" -> Ping
  | "ssh" -> Ssh
  | "dns" -> Dns
  | _ -> raise (Detail.CmdError ("Unrecognized command: "^s))

module Debug = struct

  let print = function
    | Ping -> "ping"
    | Ssh -> "ssh"
    | Dns -> "dns"
end
