%{
  let parse_error msg =
    let pos = Parsing.symbol_start_pos () in
    (* Lines are 0-indexed. *)
    let line = pos.pos_lnum + 1 in
    let msg = Printf.sprintf "%s: line %d" msg line in
    raise (Lib.Exceptions.ParseError msg)

  let cmd_parse c =
    try
      Lib.Cmd.parse c
    with e ->
      let msg = Printexc.to_string e in
      parse_error msg
%}

%token ALIAS LPAREN RPAREN ARROW ACCEPT REJECT NEWLINE EOF
%token <string> WORD

%start stmts
%type <Lib.Ast.stmt list> stmts

%%

stmt:
  | ALIAS WORD WORD
    { Lib.Ast.Alias ($2, $3, None) }
  | ALIAS WORD WORD LPAREN WORD RPAREN
    { Lib.Ast.Alias ($2, $3, Some $5) }
  | WORD WORD ARROW WORD ACCEPT
    { Lib.Ast.Test ((cmd_parse $1), $2, $4, Lib.Ast.Accept) }
  | WORD WORD ARROW WORD REJECT
    { Lib.Ast.Test ((cmd_parse $1), $2, $4, Lib.Ast.Reject) }
;

line:
  | NEWLINE {[]}
  | stmt NEWLINE { [$1] }
;

stmts:
  | { [] }
  | line stmts { $1@$2 }
;
