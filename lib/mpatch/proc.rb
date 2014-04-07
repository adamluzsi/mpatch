module MPatch

  module Include

    module Proc

      # sugar syntax for proc * operator
      #    a = ->(x){x+1}
      #    b = ->(x){x*10}
      #    c = b*a
      #    c.call(1) #=> 20
      def *(other)
        self.class.new { |*args| self[*other[*args]] }
      end

    end

  end

  require File.join 'mpatch','injector'


end
