require_relative 'small_step/add'
require_relative 'small_step/variable'
require_relative 'small_step/number'
require_relative 'small_step/machine'

# 手动引入更多

p "--machine start--"
Machine.new(
  Add.new(
    Variable.new(:x), Variable.new(:y)),
  { x: Number.new(3), y: Number.new(4) }
).run
