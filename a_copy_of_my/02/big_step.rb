require_relative './big_step/add'
require_relative './big_step/number'
require_relative './big_step/sentence'

statement = Sequence.new(
  Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
  Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
)
p statement
p statement.evaluate({})

statement = While.new(
  LessThan.new(Variable.new(:x), Number.new(5)),
  Assign.new(:x, Multiply.new(
    Variable.new(:x), Number.new(3)))
)
p statement
p statement.evaluate({ x: Number.new(1) })

# p statement