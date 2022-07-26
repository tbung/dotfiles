; Inject bash into raw multi-line string literals
; if they are assigned to something and there's a
; comment in front specifying it's bash
(
 ((comment) @_cmt
 ) .
 (expression_statement
   (assignment
     left: (identifier)
     right: (string) @bash
     )
   )
 (#eq? @_cmt "# lang: bash")
 (#lua-match? @bash "^r\"\"\"")
 (#offset! @bash 0 4 0 -3)
)
