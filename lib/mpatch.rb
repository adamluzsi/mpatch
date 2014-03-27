#encoding: UTF-8
module MPatch

  module Include;end
  module Extend;end

  Dir.glob(File.join(File.absolute_path(File.dirname(__FILE__)),"mpatch","**","*.{rb,ru}")).each{|e|require e}
  extend MPatch::Include::Module

  self.submodules.each do |module_name|

    method_name= module_name.to_s.split('::').last.downcase
    if self.methods.include?(method_name.to_s.to_sym)

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
          target_constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
          target_constant.__send__ method_name, sub_module_name
        end

      end

    end

  end

end