require 'treetop'

Treetop.load('./simple.treetop')

p parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')

# 抽象语法树
p statement = parse_tree.to_ast

statement.evaluate({ x: Number.new(1) })

statement.to_ruby

# parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')
# statement = parse_tree.to_ast
# statement.evaluate({ x: Number.new(1) })