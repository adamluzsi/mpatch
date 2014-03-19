mpatch
======

Monkey patch collection for advance helper functions

This project aim to give flexible methods to the developer by giving new inheritance to the base classes

for example

`ruby

require 'mpatch'

class Test

  def initialize

    @hello= "world"
    @sup=   "nothing"

  end

end

puts Test.new.to_hash
#> {"hello" => "world", "sup" => "nothing"}
`

But there is a lot of method, for example for modules modules / subbmodules call that retunr modules under that namespace.
Lot of metaprogrammer stuff there too :)

please do enjoy :)

ps.:

* you can get each of the modules for only include to your custom class
