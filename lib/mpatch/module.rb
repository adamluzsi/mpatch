module MPatch::Include
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
              case self.class.to_s

                when "Module"
                  return_array.push candidate if candidate.mixin_ancestors.include?(self)

                when "Class"
                  return_array.push candidate if candidate < self

              end

            end

          rescue ::ArgumentError, ::NoMethodError
          end
        end

      end
      return_array

    end

  end
end