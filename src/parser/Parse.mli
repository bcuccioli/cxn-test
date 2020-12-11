(*
 * Parse from an input channel. This could for example represent a file
 * or stdin.
 *)
val from_channel : in_channel -> Ast.stmt list

(*
 * Parse from a string. This is primarily useful for unit testing.
 *)
val from_string : string -> Ast.stmt list
