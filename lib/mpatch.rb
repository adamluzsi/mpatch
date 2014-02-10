#encoding: UTF-8
module MPatch

  Dir.glob(File.join(File.absolute_path(File.dirname(__FILE__)),"mpatch","**","*.{rb,ru}")).each{|e|require e}

end
