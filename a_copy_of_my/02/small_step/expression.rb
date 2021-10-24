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

  def reduce
    if left.reducible?
      Add.new(left.reduce, right)
    elsif right.reducible?
      Add.new(left, right.reduce)
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

  def reduce
    if left.reducible?
      Add.new(left.reduce, right)
    elsif right.reducible?
      Add.new(left, right.reduce)
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

expression = Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)
# «1 * 2 + 3 * 4»
# 当前没有考虑运算优先级，所以这种计算方式和上面👆一样
# p Multiply.new(
#   Number.new(1),
#   Multiply.new(
#     Add.new(Number.new(2), Number.new(3)),
#     Number.new(4)
#   )
# )

p expression
p expression.reducible? # true
p expression = expression.reduce

p expression.reducible?
p expression = expression.reduce

# ... 一直规约，直到 expression.reducible? 为 false
# 14
# 即 Number.new(14) 是我们设计出来的语言 Simple 表达式，而不仅仅是 Ruby 的数字

Object.send(:remove_const, :Machine) # 忘记原来的 Machine类

# 上面手动写太傻了，所以定义一个「虚拟机」
class Machine < Struct.new(:expression)
  def step
    self.expression = expression.reduce
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

p "--machine start--"
Machine.new(
  Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
  ),
).run

# boolean
# lessThan
p '--less than run--'
Machine.new(
  LessThan.new(Number.new(5), Add.new(Number.new(2), Number.new(2)))
).run
