require File.join 'mpatch','module'
require File.join 'mpatch','array'
require File.join 'mpatch','all'
require File.join 'mpatch'

puts Module.ancestors.inspect
puts ["asd"].has_any_of?(["asd"])
