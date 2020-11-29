(*
 * Indicates that there was an error parsing (either a syntax error or an
 * unrecognized command).
 *)
exception ParseError of string

module Detail = struct

  (*
   * Indicates that an unrecognized command was supplied for a test. This is
   * effectively a subset of ParseError.
   *)
  exception CmdError of string

  (* Render CmdError "x" as just "x". We need this because we embed CmdError
    inside of ParseError. *)
  let () = Printexc.register_printer
      (function
        | CmdError c -> Some c
        | _ -> None
      )

end
