require_relative 'pattern'

class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    pattern.bracket(precedence) + '*'
  end

  def precedence
    2
  end

  # \a*\ 重复 0 次或者更多次
  # 和多个'a'匹配：从它的接受状态到开始状态增加一个自由移动
  # 空字符串：让开始状态也成为接受状态，为了保证 DFA 连续  -> 增加一个可自由移动到旧的开始状态
  def to_nfa_design
    pattern_nfa_design = pattern.to_nfa_design

    start_state = Object.new
    # 让开始状态也成为接受状态
    accept_states = pattern_nfa_design.accept_states + [start_state]
    rules = pattern_nfa_design.rulebook.rules
    extra_rules =
      # 从它的接受状态到开始状态增加一个自由移动
      pattern_nfa_design.accept_states.map { |accept_state|
        FARule.new(accept_state, nil, pattern_nfa_design.start_state)
      } + # 增加一个可自由移动到旧的开始状态
        [FARule.new(start_state, nil, pattern_nfa_design.start_state)]
    rulebook = NFARulebook.new(rules + extra_rules)

    NFADesign.new(start_state, accept_states, rulebook)
  end
end