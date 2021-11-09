class DPDA < Struct.new(:current_configuration,
                        :accept_states,
                        :rulebook)
  def accepting?
    accept_states.include?(current_configuration.state)
  end

  def read_character(character)
    self.current_configuration =
      rulebook.next_configuration(current_configuration, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_configuration
    rulebook.follow_free_moves(super)
  end

  def next_configuration(character)
    if rulebook.applies_to?(current_configuration, character)
      rulebook.next_configuration(current_configuration, character)
    else
      current_configuration.stuck
    end
  end

  def stuck?
    current_configuration.stuck?
  end

  def read_character(character)
    self.current_configuration = (next_configuration(character))
  end

  def read_string(string)
    string.chars.each do |character|
      # 在无法调用的时候不调用
      read_character(character) unless stuck?
    end
  end
end

class DPDADesign < Struct.new(:start_state,
                              :bottom_character,
                              :accept_states,
                              :rulebook)
  def accepts?(string)
    to_dpda.tap { |dpda|
      dpda.read_string(string)
    }.accepting?
  end

  def to_dpda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    DPDA.new(start_configuration, accept_states, rulebook)
  end
end