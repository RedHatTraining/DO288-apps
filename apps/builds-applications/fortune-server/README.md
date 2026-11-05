# fortune-server

A very simple fortune-teller server written in Go that uses no external dependencies.

The server returns a random fortune in JSON format.
By default, it picks a fortune from a built-in list.
Set the `FORTUNES` environment variable to a comma-separated list of fortunes
to replace the built-in list; a single value produces a deterministic answer.

The `.s2i/bin` directory contains custom S2I scripts:

* The `assemble` script compiles the application and stores the value of the
  `FORTUNES` **build** environment variable in the application image.
* The `run` script provides the stored value to the server as the `FORTUNES`
  environment variable when the image starts.

As a result, the fortunes that the server returns are determined at build
time: changing the `FORTUNES` build environment variable requires a new build.
