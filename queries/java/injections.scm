; extends

(variable_declarator
  name: (identifier) @name (#eq? @name "sql")
  value: (string_literal
           (multiline_string_fragment) @injection.content)
  (#set! injection.language "sql"))

(variable_declarator
  name: (identifier) @name (#eq? @name "sql")
  value: (string_literal
           (string_fragment) @injection.content)
  (#set! injection.language "sql"))


(assignment_expression
  left: (identifier) @name (#eq? @name "sql")
  right: (string_literal
           (multiline_string_fragment) @injection.content)
  (#set! injection.language "sql"))

(assignment_expression
  left: (identifier) @name (#eq? @name "sql")
  right: (string_literal
           (string_fragment) @injection.content)
  (#set! injection.language "sql"))
