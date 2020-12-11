open Ast
open Lexer
open Lexing
open Parser

let from_channel chan =
  let lexbuf = Lexing.from_channel chan in
  Parser.stmts Lexer.token lexbuf

let from_string str =
  let lexbuf = Lexing.from_string str in
  Parser.stmts Lexer.token lexbuf
