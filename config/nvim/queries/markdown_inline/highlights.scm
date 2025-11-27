; extends

((shortcut_link) @type.definition
                 (#eq? @type.definition "[-]")
                 (#set! priority 105))
((shortcut_link
   [
    "["
    "]"
    ] @conceal
   ) @type.definition
 (#not-eq? @type.definition "[-]")
 (#set! @conceal conceal ""))
