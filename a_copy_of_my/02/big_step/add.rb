require_relative './number'
require_relative '../syntax/add'
require_relative '../syntax/multiplication'
require_relative '../syntax/less_than'

class Add
  def evaluate(environment)
    Number.new(
      left.evaluate(environment).value +
        right.evaluate(environment).value)
  end
end

class Multiply
  def evaluate(environment)
    Number.new(
      left.evaluate(environment).value *
        right.evaluate(environment).value)
  end
end

class LessThan
  def evaluate(environment)
    Boolean.new(
      left.evaluate(environment).value <
        right.evaluate(environment).value)
  end
end

# test
# p Number.new(23)
# p Variable.new(:x).evaluate({x: Number.new(23)})
# p LessThan.new(
#   Add.new(Variable.new(:x), Number.new(2)),
#   Variable.new(:y)
# ).evaluate({x: Number.new(2), y: Number.new(5) })