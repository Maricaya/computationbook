require_relative '../syntax/number'
require_relative '../syntax/boolean'
require_relative '../syntax/variable'

class Number
  def evaluate(environment)
    self
  end
end

class Boolean
  def evaluate(environment)
    self
  end
end

class Variable
  def evaluate(environment)
    environment[name]
  end
end

