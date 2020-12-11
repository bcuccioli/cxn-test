(*
 * Indicates that there was an error parsing (either a syntax error or an
 * unrecognized command).
 *)
exception ParseError of string

(*
 * Represents "shadowing" of an alias by another alias, e.g. if we say
 * `alias host ip1` and later `alias host ip2`.
 *)
exception ShadowError of string * string * string

(*
 * Indicates that the ssh process on the host machine ended unexpectedly.
 *)
exception ProcessError of string

module Detail = struct
  open Printf

  (*
   * Indicates that an unrecognized command was supplied for a test. This is
   * effectively a subset of ParseError.
   *)
  exception CmdError of string

  let () =
    Printexc.register_printer (function
      (* Render CmdError "x" as just "x". We need this because we embed
         CmdError inside of ParseError. *)
      | CmdError c -> Some c
      (* Render ShadowError in a more readable way. *)
      | ShadowError (a, v, w) ->
        Some
          (sprintf "Alias %s to %s is shadowing; already aliased to %s" a v w)
      | _ -> None)
end
