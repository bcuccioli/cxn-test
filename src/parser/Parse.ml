open Ast
open Lexer
open Lexing
open Parser

(*
 * Parse from an input channel. This could for example represent a file
 * or stdin.
 *)
let from_channel chan =
  let lexbuf = Lexing.from_channel chan in
  (Parser.stmts Lexer.token lexbuf)

(*
 * Parse from a string. This is primarily useful for unit testing.
 *)
let from_string str =
  let lexbuf = Lexing.from_string str in
  (Parser.stmts Lexer.token lexbuf)
