require File.join 'mpatch','array'
MPatch.patch!

puts ["asd"].has_any_of?(%W[ 123 hello\ world sup? asd])

require File.join 'mpatch' # require and patch all
puts Object.ancestors.inspect