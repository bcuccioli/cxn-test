module Output = struct
  open ANSITerminal

  let green = print_string [Foreground Green]

  let red = print_string [Foreground Red]
end

let () =
  let chan =
    if Array.length Sys.argv < 2 then stdin else open_in Sys.argv.(1)
  in

  let lexbuf = fun () -> Lexing.from_channel chan in
  let ast = Parsed_ast.from lexbuf in

  close_in chan;

  List.iter
    (fun test ->
      let result = Eval.Evaluate.result test in
      let status = if result.eq then "✓" else "✗" in

      let text =
        Printf.sprintf "[%s] %s:\t%s\n" status result.desc result.real
      in

      let p = if result.eq then Output.green else Output.red in
      p text)
    (Lib.Ast.bind ast)
