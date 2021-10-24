require_relative '../syntax/number'

class Number
 def to_ruby
  "-> e { #{value.inspect} }"
 end
end

require_relative '../syntax/boolean'
class Boolean
 def to_ruby
  "-> e { #{value.inspect} }"
 end
end

proc = eval(Number.new(5).to_ruby)
p proc
proc.call({})


# p Boolean.new(false).to_ruby
