open Ast
open Exceptions

module Debug = struct
  let on () = try Unix.getenv "DEBUG" = "on" with Not_found -> false
end

module Impl = struct
  let success cmd =
    if Debug.on () then print_endline ("> " ^ cmd);
    match Unix.system cmd with
      | Unix.WEXITED i -> i == 0
      | Unix.WSIGNALED i ->
        raise
          (ProcessError
             (Printf.sprintf "The ssh process was killed by signal %d" i))
      | Unix.WSTOPPED i ->
        raise
          (ProcessError
             (Printf.sprintf "The ssh process was stopped by signal %d" i))
end

type output = {
  desc: string;
  exp: string;
  real: string;
  eq: bool;
}

let eval test = Shell.cmd test |> Impl.success

let result test =
  let actual = if eval test then Accept else Reject in
  {
    desc = Print.test test;
    exp = Print.result test.res;
    real = Print.result actual;
    eq = test.res == actual;
  }
