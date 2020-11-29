open Cmd

type host = string

type result =
  | Accept
  | Reject

type stmt =
  | Alias of host * host
  | Test of Cmd.cmd * host * host * result

module Debug = struct

  open Printf

  let result_str = function
    | Accept -> "accept"
    | Reject -> "reject"

  let print = function
    | Alias (a, b) ->
      sprintf "Alias %s to %s" a b
    | Test (c, a, b, r) ->
      sprintf "%s %s to %s = %s"
        (Cmd.Debug.print c) a b (result_str r)
end
