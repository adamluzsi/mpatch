module MPatch

  module Extend

    module Random

      def string(length= 7,amount=1,hyphen= " ")
        amount_container= []
        amount.times do
          mrg= ""
          mrg= (0...length).map{ ('a'..'z').to_a[rand(26)] }.join
          amount_container.push mrg
        end
        return amount_container.join(hyphen)
      end

      def integer(length= 3)
        self.rand(length)
      end

      def boolean
        self.rand(2) == 1
      end

      def time from = Time.at(1114924812), to = Time.now
        self.rand(from..to)
      end

      def date from = Time.at(1114924812), to = Time.now
        self.rand(from..to).to_date
      end

      def datetime from = Time.at(1114924812), to = Time.now
        self.rand(from..to).to_datetime
      end

    end

  end

  require File.join 'mpatch','injector'
  inject_patches

end

## alias in Random from RND
#begin
#  (RND.singleton_methods-Object.instance_methods).each do |one_method_sym|
#    Random.class_eval do
#      define_singleton_method one_method_sym do |*args|
#        RND.__send__(one_method_sym,*args)
#      end
#    end
#  end
#end
