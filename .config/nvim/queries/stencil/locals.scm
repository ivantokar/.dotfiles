(for_tag
  variable: (identifier) @local.definition)

(for_block) @local.scope

(macro_tag
  name: (identifier) @local.definition)

(macro_parameters
  (macro_parameter
    name: (identifier) @local.definition))

(macro_block) @local.scope
