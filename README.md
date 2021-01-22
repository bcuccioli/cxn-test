# cxn-test

*Write unit tests for your network using a DSL and run them easily.*

Assertions can be specified that a connection from host A to B over a given port P either succeeds or fails.
`cxn-test` will SSH into the source host A, attempt to make the connection to B, and report whether the result
was successful.
