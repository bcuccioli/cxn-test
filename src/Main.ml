open Ast
open Lexer
open Lexing
open Parser

let () =
  let chan =
    if Array.length Sys.argv < 2 then stdin
    else (open_in Sys.argv.(1)) in

  let lexbuf = Lexing.from_channel chan in

  (Parser.stmts Lexer.token lexbuf)
  |> List.map Debug.print
  |> List.iter print_endline;

  close_in chan;
