open Lexer
open Parser

let from lexbuf =
  Parser.stmts Lexer.token (lexbuf ())
