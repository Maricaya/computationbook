require_relative 'pattern'
require_relative "../finite_automata/nfa"

class Choose < Struct.new(:first, :second)
  include Pattern

  def precedence
    0
  end

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
  end

  def to_nfa_design
    # /a\b/
    # 方法是增加一个新的起始状态，
    # 并使用自由移动把它与两台原始机器之前的起始状态连接起来
    first_nfa_design = first.to_nfa_design
    second_nfa_design = second.to_nfa_design

    start_state = Object.new
    accept_states = first_nfa_design.accept_states + second_nfa_design.accept_states

    rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules

    extra_rules = [first_nfa_design, second_nfa_design].map { |nfa_design|
      # 新的初始状态，分别和两个 NFA 的初始状态相连接
      FARule.new(start_state, nil, nfa_design.start_state)
    }

    rulebook = NFARulebook.new(rules + extra_rules)

    NFADesign.new(start_state, accept_states, rulebook)
  end
end