require_relative './finite_automata/nfa'

class NFADesign
  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end
end

# 此前，一台NFA的模拟只能从它的起始状态开始,但这个新的参数让它可以从其他任何点起步
rulebook = NFARulebook.new([
                             FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2),
                             FARule.new(2, 'b', 3),
                             FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
                           ])
nfa_design = NFADesign.new(1, [3], rulebook)
#
# p nfa_design.to_nfa.current_states
# p nfa_design.to_nfa(Set[2]).current_states
# p nfa_design.to_nfa(Set[3]).current_states
#
# p '---nfa---'
# p nfa = nfa_design.to_nfa(Set[2, 3])
# nfa.read_character('b')
# p nfa.current_states

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa_design.to_nfa(state).tap do |nfa|
      nfa.read_character(character)
    end.current_states
  end
end

# p simulation.next_state(Set[1, 2], 'a')
# p simulation.next_state(Set[1, 2], 'b')
# p simulation.next_state(Set[3, 2], 'b')
# p simulation.next_state(Set[1, 3, 2], 'b')
# p simulation.next_state(Set[1, 3, 2], 'a')

class NFARulebook
  def alphabet
    rules.map(&:character).compact.uniq
  end
end

class NFASimulation
  def rules_for(state)
    nfa_design.rulebook.alphabet.map do |character|
      FARule.new(state, character, next_state(state, character))
    end
  end
end

simulation = NFASimulation.new(nfa_design)

# p rulebook.alphabet

# p simulation.rules_for(Set[1, 2])
# p simulation.rules_for(Set[3, 2])

class NFASimulation
  def discover_states_and_rules(states)
    rules = states.flat_map { |state| rules_for(state) }
    more_states = rules.map(&:follow).to_set

    if more_states.subset?(states)
      [states, rules]
    else
      discover_states_and_rules(states + more_states)
    end
  end
end

p start_state = nfa_design.to_nfa.current_states

p simulation.discover_states_and_rules(Set[start_state])

class NFASimulation
  def to_dfa_design
    start_state = nfa_design.to_nfa.current_states
    states, rules = discover_states_and_rules(Set[start_state])
    accept_states = states.select { |state| nfa_design.to_nfa(state).acce}
  end
end