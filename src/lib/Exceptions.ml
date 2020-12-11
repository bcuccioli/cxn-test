open Printf

exception ParseError of string

exception CmdError of string

exception ShadowError of string * string * string

exception ProcessError of string

let () =
  Printexc.register_printer (function
    (* Render CmdError "x" as just "x". We need this because we embed
       CmdError inside of ParseError. *)
    | CmdError c -> Some c
    (* Render ShadowError in a more readable way. *)
    | ShadowError (a, v, w) ->
      Some (sprintf "Alias %s to %s is shadowing; already aliased to %s" a v w)
    | _ -> None)
