require 'mpatch'

class Test

  def say
    "hello world"
  end

  def sup
    "fine thx"
  end

  privatize t: :instance, ex: 'sup'

end

test1= Test.new

puts test1.sup #> fine thx

puts try{ test1.say } #> will fail and say error instead "hello world"
puts test1.__send__ :say #> hello world

test1.privatize only: 'sup'
puts try{ test1.sup } #> fail again because it's private