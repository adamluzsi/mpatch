#encoding: UTF-8
module MPatch

  Dir.glob(File.join(File.absolute_path(File.dirname(__FILE__)),"mpatch","**","*.{rb,ru}")).each{|e|require e}

  [
      MPatch::Process,
      MPatch::String,
      MPatch::Proc,
      MPatch::YAML,
      MPatch::Object,
      MPatch::File,
      MPatch::Array,
      MPatch::Integer,
      MPatch::Hash
  ].each do |module_name|

    constant= ::Object
    name=     module_name.to_s.split('::').last
    constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)

    constant.__send__ :include, module_name

  end

  [ MPatch::Random ].each do |module_name|

    constant= ::Object
    name=     module_name.to_s.split('::').last
    constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)

    constant.__send__ :extend, module_name

  end


end
