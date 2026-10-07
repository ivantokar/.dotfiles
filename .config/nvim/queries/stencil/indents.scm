(if_block
  body: (_) @indent.begin)

(elif_clause
  body: (_) @indent.begin)

(else_clause
  body: (_) @indent.begin)

(endif_tag) @indent.end

(for_block
  body: (_) @indent.begin)

(endfor_tag) @indent.end

(block_block
  body: (_) @indent.begin)

(endblock_tag) @indent.end

(macro_block
  body: (_) @indent.begin)

(endmacro_tag) @indent.end

(filter_block
  body: (_) @indent.begin)

(endfilter_tag) @indent.end

(raw_block
  body: (_) @indent.begin)

(endraw_tag) @indent.end
