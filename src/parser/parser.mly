%{
  open Ast
  open Cmd
  open Lexing

  let parse_error msg =
    let pos = Parsing.symbol_start_pos () in
    (* Lines are 0-indexed. *)
    let line = pos.pos_lnum + 1 in
    let msg = Printf.sprintf "%s: line %d" msg line in
    raise (ParseError msg)

  let cmd_parse c =
    try
      Cmd.parse c
    with e ->
      let msg = Printexc.to_string e in
      parse_error msg
%}

%token ALIAS ARROW ACCEPT REJECT NEWLINE EOF
%token <string> WORD

%start stmts
%type <Ast.stmt list> stmts

%%

stmt:
  | ALIAS WORD WORD
    { Ast.Alias ($2, $3) }
  | WORD WORD ARROW WORD ACCEPT
    { Ast.Test ((cmd_parse $1), $2, $4, Ast.Accept) }
  | WORD WORD ARROW WORD REJECT
    { Ast.Test ((cmd_parse $1), $2, $4, Ast.Reject) }
;

line:
  | NEWLINE {[]}
  | stmt NEWLINE { [$1] }
;

stmts:
  | { [] }
  | line stmts { $1@$2 }
;
