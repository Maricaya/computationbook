class Stack < Struct.new(:contents)
  def push(character)
    Stack.new([character] + contents)
  end

  def pop
    Stack.new(contents.drop(1))
  end

  def top
    contents.first
  end

  def inspect
    "#<Struct (#{top})#{contents.drop(1).join}>"
  end
end

# stack = Stack.new(%w[a b c d e])
# p stack.top
# p stack.pop.pop.top
# p stack.push('x').push('y').top
# p stack.push('x').push('y').pop.top

# stack = Stack
#           .new(['$'])
#           .push('x')
#           .push('y').push('z')
#
# p stack.top
# stack = stack.pop
# p stack.top
# stack = stack.pop
# p stack.top