
require_relative '../lib/mpatch/object'
MPatch.patch!



try { hello world }
catch{ "not hello world " }
#> "not hello world"


try { "hello world".asdaf }
catch( NoMethodError ) { |ex|
  puts "there is and error, because #{ex}"
}

#> you can cain up multiple catch for specific error
try { "hello world".asdaf }
catch( NoMethodError ) { |ex|
  puts "there is and error, because #{ex}"
}

try { "hello world".asdaf }
catch(ArgumentError) {
  puts "it was and argument error"
}

catch( NoMethodError ) { |ex|
  puts "bla bla #{ex}"
}


