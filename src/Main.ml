let () =
  let chan =
    if Array.length Sys.argv < 2 then stdin
    else (open_in Sys.argv.(1)) in

  (Parse.from_channel chan)
  |> List.map Ast.Debug.print
  |> List.iter print_endline;

  close_in chan;
