type cmd =
  | Ping
  | Ssh
  | Dns

exception CmdError of string

let () = Printexc.register_printer
    (function
      | CmdError c -> Some c
      | _ -> None
    )

let parse s = match s with
  | "ping" -> Ping
  | "ssh" -> Ssh
  | "dns" -> Dns
  | _ -> raise (CmdError ("Unrecognized command: "^s))

module Debug = struct

  let print = function
    | Ping -> "ping"
    | Ssh -> "ssh"
    | Dns -> "dns"
end
