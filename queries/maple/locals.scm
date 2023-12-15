(function_definition
  function_name: (identifier) @definition.function
  )

(parameter_list
    parameter: (identifier) @definition.parameter
    )

(variable_definition
  name: (identifier) @definition.variable
  )

[
 (while_loop)
 (if_statement)
 (block)
 (function_definition)
 ] @scope

