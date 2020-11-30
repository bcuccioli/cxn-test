open Cmd
open Exceptions

type host = string

type result =
  | Accept
  | Reject

type stmt =
  | Alias of host * host
  | Test of Cmd.cmd * host * host * result

type test = {
  cmd: Cmd.cmd;
  src: host;
  dst: host;
  res: result;
}

(*
 * "Bind" aliases to statements in order to form executable tests. We make a
 * single pass through the list of aliases and tests, meaning that aliases must
 * be defined before they are used. We explicitly prohibit shadowing of aliases.
 *)
let bind stmts =
  let vars = Hashtbl.create (List.length stmts) in

  let find_default k = match Hashtbl.find_opt vars k with
    | Some v -> v
    | None -> k in

  let next tests stmt = match stmt with
    | Alias (k, v) -> begin
      match Hashtbl.find_opt vars k with
        | Some w -> raise (ShadowError (k, v, w))
        | None -> Hashtbl.add vars k v;
      tests
    end
    | Test (cmd, src, dst, res) ->
      let t = {
        cmd = cmd;
        src = find_default src;
        dst = find_default dst;
        res =  res;
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

  let print = function
    | Alias (a, b) ->
      sprintf "Alias %s to %s" a b
    | Test (c, a, b, r) ->
      sprintf "%s %s to %s = %s" (CD.print c) a b (result_str r)

  let print_test t =
    sprintf "test: %s %s -> %s: %s"
      (CD.print t.cmd) t.src t.dst (result_str t.res)
end
