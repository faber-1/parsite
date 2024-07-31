(lang dune 3.13)

(name parsite)

(generate_opam_files true)

(source
 (github faber-1/parsite))

(authors "faber-1")

(maintainers "faber-1")

(license "MIT")

(documentation https://faber-1.github.io/parsite/)

(package
 (name parsite)
 (synopsis "A micro library for simple parsing combinators")
 (description "A micro library for simple parsing combinators")
 (depends (ocaml (>= 4.07)) dune ounit2 odoc)
 (tags
  (string ocaml functional-programming parsing-combinators parsing-library)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
