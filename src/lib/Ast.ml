open Cmd
open Exceptions

type host = string
type user = string

type result =
  | Accept
  | Reject

type stmt =
  | Alias of host * host * user option
  | Test of Cmd.cmd * host * host * result

type test = {
  cmd: Cmd.cmd;
  src: host;
  dst: host;
  res: result;
  usr: user option;
}

(*
 * "Bind" aliases to statements in order to form executable tests. We make a
 * single pass through the list of aliases and tests, meaning that aliases must
 * be defined before they are used. We explicitly prohibit shadowing of aliases.
 *)
let bind stmts =
  let vars = Hashtbl.create (List.length stmts) in
  let users = Hashtbl.create (List.length stmts) in

  let find_default t k = match Hashtbl.find_opt t k with
    | Some v -> v
    | None -> k in

  let find_opt t k =
    try Hashtbl.find t k
    with Not_found -> None in

  let next tests stmt = match stmt with
    | Alias (k, v, u) -> begin
      match Hashtbl.find_opt vars k with
        | Some w -> raise (ShadowError (k, v, w))
        | None -> begin
          Hashtbl.add vars k v;
          Hashtbl.add users k u;
        end;
      tests
    end
    | Test (cmd, src, dst, res) ->
      let t = {
        cmd = cmd;
        src = find_default vars src;
        dst = find_default vars dst;
        res = res;
        usr = find_opt users src;
      } in
      t::tests
    in
  List.fold_left next [] stmts
    |> List.rev

module Debug = struct

  open Printf
  module CD = Cmd.Debug

  let result_str = function
    | Accept -> "accept"
    | Reject -> "reject"

  let user_str = function
    | Some u -> sprintf "(%s)" u
    | None -> ""

  let print = function
    | Alias (a, b, u) ->
      sprintf "Alias %s to %s %s" a b (user_str u)
    | Test (c, a, b, r) ->
      sprintf "%s %s to %s = %s" (CD.print c) a b (result_str r)

  let print_test t =
    sprintf "test: %s %s -> %s: %s"
      (CD.print t.cmd) t.src t.dst (result_str t.res)
end
