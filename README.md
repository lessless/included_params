## IncludedResourceParams

 The IncludedResourceParams class was divided into 3 smaller ones to preserve SRP principle and mimic the real-world situation:
 - IncludedResourceParams that serves as an entry-point to the params parsing API.
 - Parser deals with the "params" and is solely responsible for the parsing raw string into a set of resources
 - Decoder operates on "resources" and is responsible for the converting raw resources like `foo.bar.baz` into Ruby representation. The `merge` method is pretty complex and can be refactored to minimize branching and increase understandability, although it serves as a solid foundation for ther future extension. See the commit message for the implementation details.

During working on the task I made an experiment of using private methods instead of the constants, just for entertainment and to see how it will look like :)

****

Use **rake** command to run the test suite
