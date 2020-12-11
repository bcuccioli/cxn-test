(**
 * Parse input into a list of statements. This function takes a lexbuf factory
 * function as input.
 *)
val from : (unit -> Lexing.lexbuf) -> Ast.stmt list
