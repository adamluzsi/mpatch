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

puts Test.convert2hash
# {"test"=>"asd"}

puts Test.new.convert2hash
# {"hello"=>"world", "no"=>"yes"}