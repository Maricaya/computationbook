class FARule < Struct.new(:state, :character, :next_state)
  def applies_to?(state, character)
    self.state == state && self.character == character
  end

  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
  end
end

class DFARulebook < Struct.new(:rules)
  def next_state(state, character)
    rule_for(state, character).follow
  end

  def rule_for(state, character)
    rules.detect { |rule| rule.applies_to?(state, character) }
  end
end

rulebook = DFARulebook.new([
                             FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
                             FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
                             FARule.new(3, 'a', 3), FARule.new(3, 'b', 3),
                           ])

# p rulebook.next_state(1, 'a')
# p rulebook.next_state(1, 'b')
# p rulebook.next_state(2, 'b')

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_state)
  end
end

# p DFA.new(1, [1, 3], rulebook).accepting?

# p DFA.new(1, [3], rulebook).accepting?

class DFA
  def read_character(character)
    self.current_state = rulebook.next_state(current_state, character)
  end
end


class DFA
  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end


p '====start===='

p dfa = DFA.new(1, [3], rulebook)
# [3].include?(1)
p dfa.accepting?

# current_state = next_state(1, 'b')
# current_state = 1
# current_state = next_state(1, 'a')
# current_state = 2
# 2, 'a' => 2
# 2, 'a' => 2
# 2, 'b' => 3
p dfa.read_string('baaab')
# [3].include(3)
p dfa.accepting?

p '--end---'

class DFADesign < Struct.new(:start_state, :accept_states, :rulebook)
  def to_dfa
    DFA.new(start_state, accept_states, rulebook)
  end

  def accepts?(string)
    # tap 方法对一个代码块求值，然后返回调用它的对象。
    to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
  end
end

# DFADesign#accepts? 用 DFADesign#to_dfa 方法创建一个 DFA 的新实例，
# 然后调用 #read_ string? 把它放到一个接受态或者拒绝态里
dfa_design = DFADesign.new(1, [3], rulebook)
p dfa_design.accepts?('a')
p dfa_design.accepts?('baa')
p dfa_design.accepts?('baba')