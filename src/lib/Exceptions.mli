(*
 * Indicates that there was an error parsing (either a syntax error or an
 * unrecognized command).
 *)
exception ParseError of string

(*
 * Indicates that an unrecognized command was supplied for a test. This is
 * effectively a subset of ParseError.
 *)
exception CmdError of string

(*
 * Represents "shadowing" of an alias by another alias, e.g. if we say
 * `alias host ip1` and later `alias host ip2`.
 *)
exception ShadowError of string * string * string

(*
 * Indicates that the ssh process on the host machine ended unexpectedly.
 *)
exception ProcessError of string
