require_relative '../syntax/assign'

# 求值产生的是一个新的环境而不是一个值
class Assign
  def to_ruby
    "-> e { e.merge({ #{name.inspect} => (#{expression.to_ruby}).call(e) }) }"
  end
end

require_relative './variable'

# p statement = Assign.new(
#   :y,
#   Add.new(
#     Variable.new(:x), Number.new(1)
#   )
# )
#
# p proc = eval(statement.to_ruby)
#
# p proc.call({x: 3})

require_relative '../syntax/do_nothing'

class DoNothing
  def to_ruby
    '-> e { e }'
  end
end

require_relative '../syntax/if'

class If
  def to_ruby
    "-> e { if (#{condition.to_ruby}).call(e)
      then (#{consequence.to_ruby}).call(e)
      else (#{alternative}).call(e)
      end }"
  end
end

require_relative '../syntax/sequence'

class Sequence
  def to_ruby
    "-> e { (#{second.to_ruby}).call(#{first.to_ruby}).call(e) }"
  end
end

require_relative '../syntax/while'

class While
  def to_ruby
    "-> e {
      while (#{condition.to_ruby}).call(e);
       e = (#{body.to_ruby}).call(e);
      end
      e
    }"
  end
end

p statement = While.new(
  LessThan.new(
    Variable.new(:x), Number.new(5)
  ),
  Assign.new(
    :x,
    Multiply.new(
      Variable.new(:x), Number.new(3)
    )
  )
)
p eval(statement.to_ruby).call({x: 1})