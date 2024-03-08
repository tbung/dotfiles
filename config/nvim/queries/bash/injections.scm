; extends
(command
  name: (command_name) @_name
  argument: (raw_string) @injection.content

  (#eq? @_name "awk")
  (#set! injection.language "awk")
)

(redirected_statement
  body: (command
          name: (command_name) @_name)
  redirect: (heredoc_redirect
              (heredoc_start)
              (heredoc_body) @injection.content
              (heredoc_end)
              )

  (#eq? @_name "awk")
  (#set! injection.language "awk")
)

