require 'mpatch'

class Test2
  @@test= "asd"
end

class Test < Test2

  def initialize

    @hello= "world"
    @no   = "yes"

  end

end

puts Test2.inherited_by.inspect
# [Test]

puts Test.conv2hash
# {"test"=>"asd"}

puts Test.new.conv2hash
# {"hello"=>"world", "no"=>"yes"}