((comment) @comment)

((string) @string)

((number) @number)

((boolean) @constant.builtin)

((nil) @constant.builtin)

(".." @operator)

["{{" "}}"] @punctuation.bracket

["{%" "%}"] @punctuation.special

["{#" "#}"] @punctuation.special

(if_tag
  "if" @keyword)

(elif_tag
  "elif" @keyword)

(else_tag
  "else" @keyword)

(endif_tag
  "endif" @keyword)

(for_tag
  "for" @keyword
  "in" @keyword)

(endfor_tag
  "endfor" @keyword)

(extends_tag
  "extends" @keyword)

(assignment_tag
  ["set" "assign"] @keyword
  target: (identifier) @variable)

(include_tag
  ["include" "render"] @keyword)

(block_tag
  "block" @keyword
  name: (identifier) @type)

(endblock_tag
  "endblock" @keyword)

(macro_tag
  "macro" @keyword
  name: (identifier) @function)

(macro_parameter
  name: (identifier) @parameter)

(endmacro_tag
  "endmacro" @keyword)

(filter_tag
  "filter" @keyword)

(endfilter_tag
  "endfilter" @keyword)

(raw_tag
  "raw" @keyword)

(endraw_tag
  "endraw" @keyword)

(generic_tag
  name: (identifier) @function.call)

(filter_chain
  name: (identifier) @function.builtin)

(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (member_expression
    (identifier)
    (identifier) @function.call))

(for_parameter
  name: (identifier) @property)

((identifier) @variable)
