(lang dune 3.13)

(name parsite)

(generate_opam_files true)

(source
 (github faber-1/parsite))

(authors "faber-1")

(maintainers "faber-1")

(license "MIT")

(documentation https://github.com/faber-1/parsite)

(package
 (name parsite)
 (synopsis "A micro library for simple parsing combinators")
 (description "A micro library for simple parsing combinators")
 (depends ocaml dune)
 (allow_empty)
 (tags
  (string ocaml functional-programming parsing-combinators parsing-library)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
