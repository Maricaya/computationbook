class Add < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end
end

class Multiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end
end

class Number < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    false
  end
end

class Machine < Struct.new(:expression, :environment)
  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end

p "--machine start--"
Machine.new(
  Add.new(
    Variable.new(:x), Variable.new(:y)),
  { x: Number.new(3), y: Number.new(4) }
).run

# 按照上面的思路很容易实现，减法、除法，布尔值:true、false，布尔运算:and\or\not
# class Boolean < Struct.new(:value)
#   def to_s
#     value.to_s
#   end
#
#   def inspect
#     "«#{self}»"
#   end
#
#   def reducible?
#     false
#   end
# end
#
# class LessThan < Struct.new(:left, :right)
#   def to_s
#     "#{left} < #{right}"
#   end
#
#   def inspect
#     "«#{self}»"
#   end
#
#   def reducible?
#     true
#   end
#
#   def reduce
#     if left.reducible?
#       LessThan.new(left.reduce, right)
#     elsif right.reducible?
#       LessThan.new(left, right.reduce)
#     else
#       Boolean.new(left.value < right.value)
#     end
#   end
# end
