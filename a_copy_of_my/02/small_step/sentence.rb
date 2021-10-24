class DoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "«#{self}»"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end

p old_environment = { y: Number.new(5) }
p new_environment = old_environment.merge({ x: Number.new(3) })
p old_environment

class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      # [statement, environment]
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({ name => expression })]
    end
  end
end

p '==start=='
p statement = Assign.new(:x, Add.new(
  Variable.new(:x), Number.new(1)
))
p environment = { x: Number.new(2) }

p statement.reducible?

# a,b = "test1","test2"
# => ["test1", "test2"]
# a "test1"
# b "test2"
# statement, environment = statement.reduce(environment)
#
# statement, environment = statement.reduce(environment)
#
# statement, environment = statement.reduce(environment)
#
# p statement.reducible?
p '==end=='

Object.send(:remove_const, :Machine)

class Machine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"
      step
    end

    puts "#{statement}, #{environment}"
  end
end

Machine.new(
  Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
  { x: Number.new(2) }
).run

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  # 如果条件能规约,那就对其进行规约；
  # 得到的结果是一个规约了的条件语句和一个没有改变的环境
  # 如果条件是表达式 true 了,就规约成结果语句和一个没有变化的环境;
  # 如果条件是表达式 false, 就规约成替代语句和一个没有变化的环境。
  def reduce(environment)
    if condition.reducible?
      [If.new(condition.reduce(environment), consequence, alternative), environment]
    else
      case condition
      when Boolean.new(true)
        [consequence, environment]
      when Boolean.new(false)
        [alternative, environment]
      end
    end
  end
end

require_relative './olean'

# 下面是规约操作
Machine.new(
  If.new(
    Variable.new(:x),
    Assign.new(:y, Number.new(1)),
    Assign.new(:y, Number.new(2))
  ),
  { x: Boolean.new(true) }
).run

p '支持没有 else'
Machine.new(
  If.new(Variable.new(:x), Assign.new(:y, Number.new(1)), DoNothing.new),
  { x: Boolean.new(false) }
).run

class Sequence < Struct.new(:first, :second)
  def to_s
    "#{first};#{second}"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  # 如果第一条语句是 do-nothing, 就规约成第二条语句和原始的环境
  # 如果第一条语句不是 do-nothing, 就对其进行规约,
  # 得到的结果是一个新的序列(规约之后的第一条语句,后边跟着第二条语句)和一个规约了的环境
  def reduce(environment)
    case first
    when DoNothing.new
      [second, environment]
    else
      reduce_first, reduce_environment = first.reduce(environment)
      [Sequence.new(reduce_first, second), reduce_environment]
    end
  end
end

p '==Sequence=='
Machine.new(
  Sequence.new(
    Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
    Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
  ),
  {}
).run
p '==Sequence end=='

class While < Struct.new(:condition, :body)
  def to_s
    "while(#{condition}) { #{body} }"
  end

  def inspect
    "«#{self}»"
  end

  def reducible?
    true
  end

  # 把 «while ( 条件 ) { 语句主体 }» 规约成
  # «if ( 条件 ) { 语句主体 ; while ( 条件 )
  # { 语句主题 } } else { do-nothing }»
  # 和一个没有改变的环境
  def reduce(environment)
    [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
  end
end

# require_relative './less_than'

# p '===--while start--==='
# Machine.new(
#   While.new(
#     LessThan.new(Variable.new(:x), Number.new(4)),
#     Assign.new(:x, Add.new(Variable.new(:x), Number.new(3)))
#   ),
#   { x: Number.new(1) }
# ).run

p '--error check--'
Machine.new(
  Sequence.new(
    Assign.new(:x, Boolean.new(true)),
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
  ),
  {}
).run
# undefined method `+' for true:TrueClass