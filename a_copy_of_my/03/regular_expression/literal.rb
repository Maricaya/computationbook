require_relative 'pattern'
require_relative "../finite_automata/nfa"

class Literal < Struct.new(:character)
  include Pattern
  def precedence
    3
  end

  def to_s
    character
  end

  def to_nfa_design
    start_state = Object.new
    accept_states = Object.new
    # 用Ruby对象实现自动机时,状态对象彼此之间一定要能区分。
    # 这里没有使用数字(如 Fixnum实例)作为状态,而是使用了新创建的 Object 实例。
    #
    # 这是为了每一个NFA都能有它自己独一无二的状态,以便把小的机器组合
    # 成大的机器,而不会意外把它们的状态也进行归并。
    #
    # 例如,如果两个不同的NFA都使用Ruby的 Fixnum对象1作为状态,
    # 在保持它们两个状态独立的情况下,它们不能合到一起。
    rule = FARule.new(start_state, character, accept_states)

    rulebook = NFARulebook.new([rule])
    NFADesign.new(start_state, [accept_states], rulebook)
  end
end