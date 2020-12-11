(**
 * Render a command into a string.
 *)
val cmd : Cmd.cmd -> string

(**
 * Render a result into a string.
 *)
val result : Ast.result -> string

(**
 * Render a test into a human-readable string, for printing.
 *)
val test : Ast.test -> string
