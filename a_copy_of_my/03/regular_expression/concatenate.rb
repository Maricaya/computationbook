require_relative 'pattern'
require_relative "../finite_automata/nfa"

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def bracket(outer_precedence)
    if precedence < outer_precedence
      '(' + to_s + ')'
    else
      to_s
    end
  end

  def inspect
    "/#{self}/"
  end

  def to_s
    [first, second].map { |pattern| pattern.bracket(precedence) }.join
  end

  def precedence
    1
  end

  # /ab/
  # 两个 NFA 的连接
  #
  # 把第一个 NFA 的出口，通过自由移动和第二个 NFA 的开始状态连接,
  # 这样，就把第一个 NFA 的每一个可接受状态变为不可接受的
  def to_nfa_design
    first_nfa_design = first.to_nfa_design
    second_nfa_design = second.to_nfa_design

    start_state = first_nfa_design.start_state
    accept_states = second_nfa_design.accept_states

    rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
    extra_rules = first_nfa_design.accept_states.map { |state|
      FARule.new(state, nil, second_nfa_design.start_state)
    }

    rulebook = NFARulebook.new(rules + extra_rules)

    NFADesign.new(start_state, accept_states, rulebook)
  end
end