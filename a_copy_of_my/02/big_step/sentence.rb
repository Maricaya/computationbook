require_relative '../syntax/assign'

class Assign
  def evaluate(environment)
    environment.merge({ name => expression.evaluate(environment) })
  end
end

require_relative '../syntax/do_nothing'

class DoNothing
  def evaluate(environment)
    environment
  end
end

require_relative '../syntax/if'

class If
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      consequence.evaluate(environment)
    when Boolean.new(false)
      alternative.evaluate(environment)
    end
  end
end

require_relative '../syntax/sequence'
# 第一个语句求值的结果就成为第二个语句求值的环境。
class Sequence
  def evaluate(environment)
    second.evaluate(first.evaluate(environment))
  end
end

require_relative '../syntax/while'

class While
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      # 对循环求值得到一个新的环境
      # 然后我们把那个环境传回当前方法中，开始下一次迭代
      evaluate(body.evaluate(environment))
    when Boolean.new(false)
      environment
    end
  end
end