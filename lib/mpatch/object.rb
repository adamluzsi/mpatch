module MPatch
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

  end
end