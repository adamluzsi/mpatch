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

  end
end