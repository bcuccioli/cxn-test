open Ast
open Exceptions

module Debug = struct
  let on () = try Unix.getenv "DEBUG" = "on" with Not_found -> false
end

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

type output = {
  desc: string;
  exp: string;
  real: string;
  eq: bool;
}

let result test =
  let result = Shell.cmd test |> success in
  let actual = if result then Accept else Reject in
  {
    desc = Print.test test;
    exp = Print.result test.res;
    real = Print.result actual;
    eq = test.res == actual;
  }
