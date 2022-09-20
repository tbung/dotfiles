; extends
; Inject bash into raw string literals
; if they are assigned to something that starts
; with `BASH_`
; HACK: also works for `r"""` cause `""` is an empty string
(
 (expression_statement
   (assignment
     left: (identifier) @_id
     right: (string) @bash
     )
   )
 (#match? @_id "(BASH_|bash_).*")
 (#lua-match? @bash "^r\"")
 (#offset! @bash 0 2 0 -1)
)
