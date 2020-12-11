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

let bind stmts =
  let vars = Hashtbl.create (List.length stmts) in
  let users = Hashtbl.create (List.length stmts) in

  let find_default t k =
    match Hashtbl.find_opt t k with
      | Some v -> v
      | None -> k
  in

  let find_opt t k = try Hashtbl.find t k with Not_found -> None in

  let next tests = function
    | Alias (k, v, u) -> (
      match Hashtbl.find_opt vars k with
        | Some w -> raise (ShadowError (k, v, w))
        | None ->
          Hashtbl.add vars k v;
          Hashtbl.add users k u;
          tests)
    | Test (cmd, src, dst, res) ->
      let t =
        {
          cmd;
          src = find_default vars src;
          dst = find_default vars dst;
          res;
          usr = find_opt users src;
        }
      in
      t :: tests
  in
  List.fold_left next [] stmts |> List.rev
