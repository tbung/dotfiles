; extends

(
 (strikethrough) @text.strike
 (#offset! @text.strike 0 1 0 -1)
)

(
 (strikethrough (emphasis_delimiter) @_conceal)
 (#set! conceal "")
)
