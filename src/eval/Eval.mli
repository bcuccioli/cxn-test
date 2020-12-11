(**
 * The output record from evaluating a test.
 *)
type output = {
  desc: string;
  exp: string;
  real: string;
  eq: bool;
}

(**
 * Evaluate a test and return a record indicating the expectation and the
 * actual result.
 *)
val result : Ast.test -> output
