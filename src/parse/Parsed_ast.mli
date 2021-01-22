(**
 * Parse input into a list of statements. This function takes a lexbuf factory
 * function as input.
 *)
val from : (unit -> Lexing.lexbuf) -> Lib.Ast.stmt list
