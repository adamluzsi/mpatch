module MPatch

  module Include

    module Integer

      # because for i in integer/fixnum not working,
      # here is a little patch
      def each &block
        self.times do |number|
          block.call   number
        end
      end

    end

  end

  require File.join 'mpatch','injector'
  inject_patches

end
