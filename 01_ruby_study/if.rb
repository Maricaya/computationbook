x = 4
puts '01 -- this appears to be false.' unless x == 4
puts '02 -- this appears to be true.' if x == 4
if x == 4
  puts '03 -- this appears to be true.'
end

unless x == 4
  puts '04 -- this appears to be false'
else
  puts '05 -- this appears to be true'
end

puts '06 -- true' if not true

puts '07 -- true2' if !true

# ------ while until -----
x = x + 1 while x < 10
puts x