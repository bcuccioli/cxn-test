type host = string

type user = string

(**
 * Represents the expected and actual results of a test.
 *)
type result =
  | Accept
  | Reject

(**
 * A statement which is the result of parsing. This must be "bound" (aliases
 * resolved) in order to produce a type which can be evaluated.
 *)
type stmt =
  | Alias of host * host * user option
  | Test of Cmd.cmd * host * host * result

(**
 * A test which can be evaluated.
 *)
type test = {
  cmd: Cmd.cmd;
  src: host;
  dst: host;
  res: result;
  usr: user option;
}

(**
 * "Bind" aliases to statements in order to form executable tests. We make a
 * single pass through the list of aliases and tests, meaning that aliases must
 * be defined before they are used. We explicitly prohibit shadowing of aliases.
 *)
val bind : stmt list -> test list
