require File.join 'mpatch','array'

# sugar syntax for Array.__send__ :include/:extend , ::MPatch::Module::Name
MPatch.inject # == Array.__send__ :include, MPatch::Include::Array

puts ["asd"].has_any_of?(%W[ 123 hello\ world sup? asd])
