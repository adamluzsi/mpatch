module MPatch

  module Include

    module Module

      # return the module objects direct sub modules
      def submodules
        constants.collect {|const_name| const_get(const_name)}.select {|const| const.class == ::Module}
      end

      # return the module objects direct sub modules
      def subclasses
        constants.collect {|const_name| const_get(const_name)}.select {|const| const.class == ::Class}
      end

      alias :modules :submodules
      alias :classes :subclasses

      def mixin_ancestors(include_ancestors=true)
        ancestors.take_while {|a| include_ancestors || a != superclass }.
            select {|ancestor| ancestor.instance_of?( ::Module ) }
      end

      def inherited_by *args

        if args.empty?
          args.push(::Class)
          args.push(::Module)
        end

        return_array= []
        args.each do |type_name|

          ::ObjectSpace.each_object(type_name) do |candidate|
            begin

              if !return_array.include?(candidate) && candidate != self

                #> can't make subclass of Class so == is enough
                case true

                  when self.class == ::Module
                    return_array.push candidate if candidate.mixin_ancestors.include?(self)

                  when self.class == ::Class
                    return_array.push candidate if candidate < self

                end

              end

            rescue ::ArgumentError, ::NoMethodError

            end
          end

        end
        return return_array

      end


      def alias_singleton_methods_from class_name, *sym_names

        method_names= sym_names.map{|e|e.to_s}
        method_names= class_name.singleton_methods if method_names.empty?

        method_names.each do |sym_name|
          self.define_singleton_method(sym_name) { |*args|

            if class_name.method(sym_name).parameters.empty?
              class_name.method(sym_name).call
            else
              class_name.method(sym_name).call *args
            end

          }
        end

      end

      def alias_instance_methods_from class_name, *sym_names

        method_names= sym_names.map{|e|e.to_s}
        method_names= class_name.instance_methods if method_names.empty?

        method_names.each do |sym_name|
          self.__send__ :define_method, sym_name, class_name.instance_method(sym_name)
        end

      end

      def hello
        "hello"
      end

      #convert class instance instance variables into a hash object
      def convert_to_hash

        tmp_hash= {}
        self.class_variables.each do|var|
          tmp_hash[var.to_s.delete("@@")] = self.class_variable_get(var)
        end

        return tmp_hash

      end
      alias :conv2hash :convert_to_hash

    end

  end

  module Extend

    module Module

      def convert_instance_methods_to_singleton_methods

        self.instance_methods.each do |symbol|
          module_function symbol
          public symbol
        end

      end
      alias :instances2singletons :convert_instance_methods_to_singleton_methods

    end

  end

  require File.join 'mpatch','injector'


end
