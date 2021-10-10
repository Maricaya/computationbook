# last problem
real_number = rand(10)
puts "Please enter the random number you guessed, 0-10"
random = gets.to_i

if random > real_number
  puts "bigger"
elsif random < real_number
  puts "smaller"
else
  puts "right!"
end
puts real_number