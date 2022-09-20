((
  (list_marker_minus)
  [
  (task_list_marker_unchecked)
  (task_list_marker_checked)
  ]
  ) @conceal
  (#set! conceal ""))

(
  (task_list_marker_unchecked)
   @unchecked
  ; (#set! conceal "✕"))
  (#set! conceal "◎"))

(
  (task_list_marker_checked)
   @checked
  (#set! conceal "✔")
)
