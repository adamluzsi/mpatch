module MPatch

  class << self

    def inject_patches

      begin
        @@valid_inject_cmd.nil?
      rescue ::NameError
        return nil
      end

      self.submodules.each do |module_name|

        method_name= module_name.to_s.split('::').last.downcase.to_s.to_sym

        module_name.__send__ :extend, MPatch::Include::Module
        module_name.submodules.each do |sub_module_name|

          constant= ::Object
          constant_name= sub_module_name.to_s.split('::').last
          array_of_target_constant= []

          case true

            when sub_module_name.to_s.include?('And')
              sub_module_name.to_s.split('::').last.split('And').each do |tag_module|
                array_of_target_constant.push tag_module
              end

            else
              array_of_target_constant.push constant_name

          end

          array_of_target_constant.each do |name|

            begin
              target_constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
              target_constant.__send__ method_name, sub_module_name
            rescue ::NoMethodError => ex
              STDERR.puts ex
            end

          end

        end

      end

    end

  end

  require File.join 'mpatch','module'

  @@valid_inject_cmd= true
  extend  MPatch::Include::Module

end