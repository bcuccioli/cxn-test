{
  open Parser

  let next_line lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
    }
}

let word = ['a'-'z']+
let comment = '#'[^ '\n']*'\n'

rule token = parse
  | comment    { next_line lexbuf; NEWLINE }
  | ['\n']     { next_line lexbuf; NEWLINE }
  | [' ' '\t'] { token lexbuf }
  | "alias"    { ALIAS }
  | "->"       { ARROW }
  | "accept"   { ACCEPT }
  | "reject"   { REJECT }
  | word as w  { WORD w }
  | eof        { EOF }
