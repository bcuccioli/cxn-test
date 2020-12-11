(**
 * Supported command types.
 *)
type cmd =
  | Ping
  | Ssh
  | Dns

(**
 * Parse a string into a supported command type, or raise CmdError if the
 * string is unrecognized.
 *)
val parse : string -> cmd
