; ; Lower priority to prefer @parameter when identifier appears in parameter_declaration.
; ((identifier) @variable (#set! "priority" 95))
;
; ; [
; ; ] @keyword
;
; ; [
; ; ] @keyword.operator
; ; (alignof_expression . _ @keyword.operator)


(function_call
  caller: (assignable) @function)

(fn_access
   (identifier) @function)

(comment) @comment

(function_definition
  function_name: (identifier) @function.definition
  )
(function_definition
  function_name: (identifier) @function.definition
  (parameter_list
    parameter: (identifier) @parameter
    (#set! "priority" 90))
  )

    ; (block)

(fn
  ) @keyword.function
;
"return" @keyword.return
;
;
[
 "where"
] @keyword.conditional
;
; ; [
; ; ] @preproc
;
;
; "import" @include

; (import_expression
;   (import_path) @string
;
;   )
;
[ "," ] @punctuation.delimiter
;
; ; "..." @punctuation.special
;
[ "(" ")" "[" "]" "{" "}"] @punctuation.bracket
;
[
  "="

  "-"
  ; "*"
  ; "/"
  "+"
  ; "."

  ; "<"
  "=="
  (arrow)
  ; ">="
  ; ">"
  ;
  ; "+="
] @operator
;
;; Make sure the comma operator is given a highlight group after the comma
;; punctuator so the operator is highlighted properly.
; (comma_expression [ "," ] @operator)
;
[
  (boolean_literal)
] @boolean
;
; ; (conditional_expression [ "?" ":" ] @conditional.ternary)
;
(string_literal) @string
; ; (system_lib_string) @string
(escape_sequence) @string.escape
;
; ; (null) @constant.builtin
(number) @number
(character_literal) @character
;
; ; ((preproc_arg) @function.macro (#set! "priority" 90))
; ; (preproc_defined) @function.macro
;
; (((field_expression
;      (field_identifier) @property)) @_parent
;  (#not-has-parent? @_parent template_method function_declarator call_expression))
;
; (field_designator) @property
; (((field_identifier) @property)
;  (#has-ancestor? @property field_declaration)
;  (#not-has-ancestor? @property function_declarator))
;
; (statement_identifier) @label
;
[
  (raw_type)
] @type

[
  (let)
] @keyword
;
; (storage_class_specifier) @storageclass
;
; [
;   (type_qualifier)
;   (gnu_asm_qualifier)
;   "__extension__"
; ] @type.qualifier
;
; (linkage_specification
;   "extern" @storageclass)
;
; (type_definition
;   declarator: (type_identifier) @type.definition)
;
; (primitive_type) @type.builtin
;
; (sized_type_specifier _ @type.builtin type: _?)
;
; ((identifier) @constant
;  (#lua-match? @constant "^[A-Z][A-Z0-9_]+$"))
; (preproc_def (preproc_arg) @constant
;   (#lua-match? @constant "^[A-Z][A-Z0-9_]+$"))
; (enumerator
;   name: (identifier) @constant)
; (case_statement
;   value: (identifier) @constant)
;
; ; ((identifier) @constant.builtin
; ;   (#any-of? @constant.builtin
; ;     "stderr" "stdin" "stdout"
; ;     "__FILE__" "__LINE__" "__DATE__" "__TIME__"
; ;     "__STDC__" "__STDC_VERSION__" "__STDC_HOSTED__"
; ;     "__cplusplus" "__OBJC__" "__ASSEMBLER__"
; ;     "__BASE_FILE__" "__FILE_NAME__" "__INCLUDE_LEVEL__"
; ;     "__TIMESTAMP__" "__clang__" "__clang_major__"
; ;     "__clang_minor__" "__clang_patchlevel__"
; ;     "__clang_version__" "__clang_literal_encoding__"
; ;     "__clang_wide_literal_encoding__"
; ;     "__FUNCTION__" "__func__" "__PRETTY_FUNCTION__"
; ;     "__VA_ARGS__" "__VA_OPT__"))
; ; (preproc_def (preproc_arg) @constant.builtin
; ;   (#any-of? @constant.builtin
; ;     "stderr" "stdin" "stdout" ;     "__FILE__" "__LINE__" "__DATE__" "__TIME__"
; ;     "__STDC__" "__STDC_VERSION__" "__STDC_HOSTED__"
; ;     "__cplusplus" "__OBJC__" "__ASSEMBLER__"
; ;     "__BASE_FILE__" "__FILE_NAME__" "__INCLUDE_LEVEL__"
; ;     "__TIMESTAMP__" "__clang__" "__clang_major__"
; ;     "__clang_minor__" "__clang_patchlevel__"
; ;     "__clang_version__" "__clang_literal_encoding__"
; ;     "__clang_wide_literal_encoding__"
; ;     "__FUNCTION__" "__func__" "__PRETTY_FUNCTION__"
; ;     "__VA_ARGS__" "__VA_OPT__"))
;
; (attribute_specifier
;   (argument_list (identifier) @variable.builtin))
; ((attribute_specifier
;   (argument_list (call_expression
;                    function: (identifier) @variable.builtin))))
;
; ((call_expression
;   function: (identifier) @function.builtin)
;   (#lua-match? @function.builtin "^__builtin_"))
; ((call_expression
;    function: (identifier) @function.builtin)
;   (#has-ancestor? @function.builtin attribute_specifier))
;
; ;; Preproc def / undef
; (preproc_def
;   name: (_) @constant)
; (preproc_call
;   directive: (preproc_directive) @_u
;   argument: (_) @constant
;   (#eq? @_u "#undef"))
;
; (call_expression
;   function: (field_expression
;     field: (field_identifier) @function.call))
; (function_declarator
;   declarator: (identifier) @function)
; (function_declarator
;   declarator: (parenthesized_declarator
;                 (pointer_declarator
;                   declarator: (field_identifier) @function)))
; (preproc_function_def
;   name: (identifier) @function.macro)
;
; (comment) @comment @spell
;
; ((comment) @comment.documentation
;   (#lua-match? @comment.documentation "^/[*][*][^*].*[*]/$"))
;
; ;; Parameters
; (parameter_declaration
;   declarator: (identifier) @parameter)
;
; (parameter_declaration
;   declarator: (array_declarator) @parameter)
;
; (parameter_declaration
;   declarator: (pointer_declarator) @parameter)
;
; ; K&R functions
; ; To enable support for K&R functions,
; ; add the following lines to your own query config and uncomment them.
; ; They are commented out as they'll conflict with C++
; ; Note that you'll need to have `; extends` at the top of your query file.
; ;
; ; (parameter_list (identifier) @parameter)
; ;
; ; (function_definition
; ;   declarator: _
; ;   (declaration
; ;     declarator: (identifier) @parameter))
; ;
; ; (function_definition
; ;   declarator: _
; ;   (declaration
; ;     declarator: (array_declarator) @parameter))
; ;
; ; (function_definition
; ;   declarator: _
; ;   (declaration
; ;     declarator: (pointer_declarator) @parameter))
;
; (preproc_params (identifier) @parameter)
;
; [
;   "__attribute__"
;   "__declspec"
;   "__based"
;   "__cdecl"
;   "__clrcall"
;   "__stdcall"
;   "__fastcall"
;   "__thiscall"
;   "__vectorcall"
;   (ms_pointer_modifier)
;   (attribute_declaration)
; ] @attribute
