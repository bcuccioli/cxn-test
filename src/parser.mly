%{
  open Ast
  open Lexing

  exception ParseError of string

  let parse_error _ =
    let pos = Parsing.symbol_start_pos () in
    (* Lines are 0-indexed. *)
    let line = pos.pos_lnum + 1 in

    raise (ParseError (Printf.sprintf "Line: %d" line))
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
    { Ast.Test ($1, $2, $4, Ast.Accept) }
  | WORD WORD ARROW WORD REJECT
    { Ast.Test ($1, $2, $4, Ast.Reject) }
;

line:
  | NEWLINE {[]}
  | stmt NEWLINE { [$1] }
;

stmts:
  | { [] }
  | line stmts { $1@$2 }
;
