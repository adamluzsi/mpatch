
require_relative '../lib/mpatch/array'
MPatch.patch!

asd= [1,2,3,4,5]

puts asd.inspect

puts asd.skip.inspect
puts asd.inspect
asd.skip!.inspect
puts asd.inspect

puts asd.pinch.inspect
puts asd.inspect

asd.pinch!.inspect
puts asd.inspect
