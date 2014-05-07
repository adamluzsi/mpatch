
require_relative '../lib/mpatch/module'
require_relative '../lib/mpatch/class'
MPatch.patch!

class Test

  def initialize
    @hello= "world"
    @no   = "yes"
  end

end

puts Test.ancestors

test= Test.new
# puts test.methods#-Object.methods

# puts Test.new.convert2hash