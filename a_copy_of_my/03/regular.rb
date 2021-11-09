require_relative 'regular_expression/literal'
require_relative 'regular_expression/choose'
require_relative 'regular_expression/concatenate'
require_relative 'regular_expression/empty'
require_relative 'regular_expression/repeat'

# p pattern =
#     Repeat.new(
#       Choose.new(
#         Concatenate.new(Literal.new('a'), Literal.new('b')),
#         Literal.new('a')
#       )
#     )

# p nfa_design = Empty.new.to_nfa_design
# p nfa_design.accepts?('')
#
# p nfa_design.accepts?('a')
# p nfa_design = Literal.new('a').to_nfa_design
# p nfa_design.accepts?('')
# p nfa_design.accepts?('a')
# p nfa_design.accepts?('b')

# p Empty.new.matches?('a')
# p Literal.new('a').matches?('a')

# p pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
# p pattern.matches?('a')
# p pattern.matches?('ab')
# p pattern.matches?('abc')

# 这又是一个组合型指称语义的例子:
# 复合正则表达式的NFA指称由它每部分NFA的指称组成。
# p pattern = Concatenate.new(
#   Literal.new('a'),
#   Concatenate.new(Literal.new('b'), Literal.new('c'))
# )
# p pattern.matches?('abc')

# p pattern = Choose.new(Literal.new('a'), Literal.new('b'))
# p pattern.matches?('a')
# p pattern.matches?('b')
# p pattern.matches?('c')

# p pattern = Repeat.new(Literal.new('a'))
# p pattern.matches?('')
# p pattern.matches?('a')
# p pattern.matches?('aaa')
# p pattern.matches?('bbb')

p pattern =
  Repeat.new(
    Concatenate.new(
      Literal.new('a'),
      Choose.new(Empty.new, Literal.new('b'))
    )
  )

p pattern.matches?('')
p pattern.matches?('a')
p pattern.matches?('ab')
