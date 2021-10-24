require_relative '../syntax/variable'

class Variable
  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end

# p expression = Variable.new(:x)
# p expression.to_ruby
# p proc = eval(expression.to_ruby)
# p proc.call({ x: 7 })

require_relative '../syntax/add'

class Add
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }"
  end
end

require_relative '../syntax/multiplication'

class Multiply
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
  end
end

require_relative '../syntax/less_than'

class LessThan
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
  end
end

require_relative './number'
# p '===start='
# environment = { x: 3 }
#
# p proc = eval(Add.new(
#   Variable.new(:x), Number.new(1)
# ).to_ruby)
#
# p proc.call(environment)
#
# p proc = eval(LessThan.new(
#   # x +1 < 3
#   Add.new(
#     Variable.new(:x), Number.new(1)
#   ),
#   Number.new(3)
# ).to_ruby)
#
# p proc.call(environment)
#
