require_relative '../03/finite_automata/nfa'

rulebook = NFARulebook.new([
                             FARule.new(0, '(', 1),
                             FARule.new(1, ')', 0),
                             FARule.new(1, '(', 2),
                             FARule.new(2, ')', 1),
                             FARule.new(2, '(', 3),
                             FARule.new(3, ')', 2),
                           ])

# p nfa_design = NFADesign.new(0, [0], rulebook)
#
# p nfa_design.accepts?('(()')
# p nfa_design.accepts?('())')
# p nfa_design.accepts?('(())')
# p nfa_design.accepts?('(()(()()))')
#
# 可是这种设计有一个严重的缺陷:如果括号的嵌套等级超过3,它就会失败。
# 但是,我们如何设计支持任意嵌套级别、能识别任意平衡字符串的NFA呢?
# 结论是设计不出来:一台有限自动机的状态数总是有限的

balanced =
  /\A(?<brackets>\(\g<brackets>*\))*\z/x
p %w[(() ()) (()) (()(()())) ((((((((((()))))))))))].grep(balanced)
