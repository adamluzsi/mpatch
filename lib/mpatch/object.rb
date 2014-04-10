module MPatch

  module Include

    module Object

      def boolean?
        !!self == self
      end

      def true?
        self == true
      end

      def false?
        self == false
      end

      def class?
        self.class == ::Class
      end

      # basic validations for those who fear the DUCK!
      def must_be class_name
        if class_name.class == ::Class
          begin
            if self.class != class_name
              raise ::ArgumentError, "invalid parameter given: #{self}"
            end
          end
        else
          begin
            if self != class_name
              raise ::ArgumentError, "invalid parameter given: #{self}"
            end
          end
        end
        return self
      end

      # The hidden singleton lurks behind everyone
      def metaclass; class << self; self; end; end

      # extend the metaclass with an instance eval
      def meta_eval &blk; metaclass.instance_eval &blk; end

      # Adds methods to a metaclass
      def meta_def name, &blk
        meta_eval { define_method name, &blk }
      end

      # Defines an instance method within a class
      def class_def name, &blk
        class_eval { define_method name, &blk }
      end

      # constantize object
      def constantize

        camel_cased_word= self.to_s
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = ::Object
        names.each do |name|
          constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end

      #convert class instance instance variables into a hash object
      def convert_to_hash

        unless self.class.class <= ::Class
          super
          #raise ::NoMethodError, "undefined method `to_hash' for #{self.inspect}"
        end

        tmp_hash= ::Hash.new()

        self.instance_variables.each do|var|
          tmp_hash[var.to_s.delete("@")] = self.instance_variable_get(var)
        end

        return tmp_hash

      end

      # this will check that the class is
      # defined or not in the runtime memory
      def class_exists?
        klass = ::Module.const_get(self)
        return klass.is_a?(::Class)
      rescue ::NameError
        return false
      end

      # This will convert a symbol or string and format to be a valid
      # constant name and create from it a class with instance attribute accessors
      # Best use is when you get raw data in string from external source
      # and you want make them class objects
      #
      #   :hello_world.to_class(:test)
      #   HelloWorld.to_class(:sup)
      #   hw_var = HelloWorld.new
      #   hw_var.sup = "Fine thanks!"
      #   hw_var.test = 5
      #
      #   puts hw_var.test
      #
      #   #> produce 5 :Integer
      #
      #   you can also use this formats
      #   :HelloWorld , "hello.world",
      #   "hello/world", "Hello::World",
      #   "hello:world"...
      def convert_to_class(*attributes)

        unless self.class <= ::Symbol || self.class <= ::String || self.class <= ::Class
          raise ::ArgumentError, "object must be symbol or string to make able build class to it"
        end

        class_name= self.to_s

        unless self.class <= ::Class

          class_name= class_name[0].upcase+class_name[1..class_name.length]
          %w[ _ . : / ].each do |one_sym|

            loop do
              index_nmb= class_name.index(one_sym)
              break if index_nmb.nil?
              class_name[index_nmb..index_nmb+1]= class_name[index_nmb+1].upcase
            end

          end

        end

        create_attribute = ::Proc.new do |*args|

        end

        unless class_name.class_exists?

          self.class.const_set(
              class_name,
              ::Class.new
          )

        end


        class_name.constantize.class_eval do
          attributes.each do |one_attribute|
            attr_accessor one_attribute.to_s.to_sym
          end
        end



        return true

      end

      alias :create_attributes :convert_to_class

      # this is used for make private methods in an object
      # you can also use this to convert already defined methods in an object or class
      # use:
      #
      #   privatize in: 'hello_world'         #> make hello world method private in the self obj
      #
      #   privatize target: 'instance'        #> you can use this in a class to make instance methods private
      #   privatize target: 'singleton'       #> you can use this in a class to make self methods private
      #
      #   privatize ex: Symbol/String/Array   #> you can use this for make exceptions what should be not touched in the prcs
      #   privatize in: Symbol/String/Array   #> you can use this for make targeted collection of methods for privatize
      #
      def privatize opts= {}

        unless opts.class <= Hash
          raise ArgumentError,"invalid input for options"
        end

        %W[ e ex exc ].each do |str_sym|
          opts[:exclude] ||= opts[str_sym.to_sym]
        end

        %W[ i in inc only methods ].each do |str_sym|
          opts[:include] ||= opts[str_sym.to_sym]
        end

        %W[ t target ].each do |str_sym|
          opts[:target] ||= opts[str_sym.to_sym]
        end

        opts[:target] ||= 's'
        opts[:target]= opts[:target].to_s.downcase

        unless opts[:target][0] == "s" || opts[:target][0] == "i"
          %W[ singleton instance ].include?(opts[:target].to_s)
          raise ArgumentError, [
              "invalid options for target, you should use the following: ",
              "\n\tsingleton for targeting the singleton class what is de",
              "fault\n\tinstance for targeting the object instance methods."
          ].join
        end

        opts[:exclude] ||= []

        if opts[:target][0] == 'i' && self.class <= Module
          opts[:include] ||= self.instance_methods.map{|e| e.to_s }
        else
          opts[:target]= 's'
          opts[:include] ||= self.methods.map{|e| e.to_s }

        end

        [:include,:exclude].each do |array_name|

          unless opts[array_name].class <= Array
            opts[array_name]= [ opts[array_name] ]
          end

          opts[array_name].map!{ |element| ( element.class == String ? element : element.to_s ) }

        end

        opts[:exclude].push('__send__').push('object_id')

        if opts[:target][0] == 's'

          self.instance_eval do

            opts[:include].each do |sym|

              unless opts[:exclude].include?(sym)
                metaclass.__send__ :private, sym
              end

            end
          end

        elsif opts[:target][0] == 'i'

          opts[:include].each do |sym|

            unless opts[:exclude].include?(sym)
              self.__send__ :private, sym
            end

          end

        else
          STDERR.puts "invalid target definition"

        end

      end



      def try(exception= Exception,&block)

        unless exception <= Exception
          raise ArgumentError, "invalid exception class"
        end

        begin
          return block.call
        rescue exception => ex
          @ruby_try_block_exception_tunel= ex
          return ex
        end

      end

      def catch exception = Exception, &block

        if @ruby_try_block_exception_tunel.nil?
          return nil
        end

        if @ruby_try_block_exception_tunel.class <= Exception

          begin
            block.call @ruby_try_block_exception_tunel
          rescue ArgumentError
            block.call
          end

        else
          raise @ruby_try_block_exception_tunel.class,@ruby_try_block_exception_tunel.to_s
        end

      end


    end

  end

  require File.join 'mpatch','injector'


end