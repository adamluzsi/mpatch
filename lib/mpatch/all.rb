#encoding: UTF-8
module MPatch

  Dir.glob(File.join(File.absolute_path(File.dirname(__FILE__)),"*.{rb,ru}")).each{|e|require e}
  self.inject_patches

end