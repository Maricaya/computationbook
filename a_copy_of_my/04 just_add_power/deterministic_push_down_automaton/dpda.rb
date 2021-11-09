require_relative './stack'
require_relative './pad_rule'
require_relative './pad_configuration'
require_relative './dpda_rulebook'
require_relative './dpda_design'

rule = PADRule.new(1, '(', 2, '$', %w[b $])
configuration = PDAConfiguration.new(1, Stack.new(['$']))
rule.applies_to?(configuration, '(')

p rule.follow(configuration)

# $ 表示到了栈的底部
# 每当想要检测栈是否为空时，检查这个符号就可以了
# 使用这个约定时，最重要的是永远不要让栈真的变空,
# 因为在栈顶为空时，没有规则可以应用。
rulebook = DPDARulebook.new([
                              PADRule.new(1, '(', 2, '$', %w[b $]),
                              PADRule.new(2, '(', 2, 'b', %w[b b]),
                              PADRule.new(2, ')', 2, 'b', %w[]),
                              PADRule.new(2, nil, 1, '$', %w[$]),
                            ])

# p configuration = rulebook.next_configuration(configuration, '(')
# p configuration = rulebook.next_configuration(configuration, '(')
# p configuration = rulebook.next_configuration(configuration, ')')
# p configuration = rulebook.next_configuration(configuration, ')')

# 代替手工操作
# class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
#   def accepting?
#     accept_states.include?(current_configuration.state)
#   end
#
#   def read_character(character)
#     self.current_configuration =
#       rulebook.next_configuration(current_configuration, character)
#   end
#
#   def read_string(string)
#     string.chars.each do |character|
#       read_character(character)
#     end
#   end
#
#   def current_configuration
#     rulebook.follow_free_moves(super)
#   end
# end

dpda = DPDA.new(
  PDAConfiguration.new(1, Stack.new(['$'])),
  [1],
  rulebook
)

# p dpda.accepting?
# dpda.read_string('(()')
# p dpda.accepting?
# p dpda.current_configuration
#
# p configuration = PDAConfiguration.new(2, Stack.new(['$']))
# p rulebook.follow_free_moves(configuration)

# 这些无限循环毫无用处,因此我们在设计下推自动机的时侯要注意避免它们
# stack level too deep
# p DPDARulebook.new(
#   [PADRule.new(1, nil, 1, '$', ['$'])])
#               .follow_free_moves(PDAConfiguration.new(1, Stack.new(['$'])))


# dpda.read_string('(()(')
# p dpda.accepting?
# p dpda.current_configuration
# dpda.read_string('))()')
# p dpda.accepting?
# p dpda.current_configuration

dpda_design = DPDADesign.new(1, '$', [1], rulebook)
p dpda_design.accepts?('(((((((((())))))))))')
p dpda_design.accepts?('()(())((()))(((())))')
p dpda_design.accepts?('()(())((()))(((())))(')
# 下面不应该调用
p dpda_design.accepts?(')')

