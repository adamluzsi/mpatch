mpatch
======

Monkey patch collection for advance helper functions

This project aim to give flexible methods to the developer by giving new methods by inheritance to the base classes.
This will result in lot of helper methods, and metaprograming tricks

example with Class methods


```ruby
    require 'mpatch'

    class Test

      def initialize

        @hello= "world"
        @sup=   "nothing"

      end

    end

    puts Test.new.convert_to_hash
    #> {"hello" => "world", "sup" => "nothing"}
```

The module give you tools in your hand for inheritance handle.
For example:

```ruby
    puts Models::MongoidClassName.mixin_ancestors.include? Mongoid::Document
    #> true

    puts Mongoid::Document.inherited_by.inspect
    #> [MongoidClassName]

    class Test

    end

    module Hello
      class World < Test
      end
    end

    puts Test.inherited_by.inspect
    #> [Hello::World]

    module ParentModule

    end

    module TargetModule
      include ParentModule
    end

    module SomeModuleThatInclude
      include TargetModule
    end

    class SomeClassThatInclude
      include TargetModule
    end

    puts TargetModule.inherited_by.inspect
    #>[SomeClassThatInclude, SomeModuleThatInclude]

    puts TargetModule.inherited_by(Class).inspect
    #>[SomeClassThatInclude]
```

## require for use only

```ruby
    require File.join 'mpatch','array' # == require 'mpatch/array' but works on windows alike

    # sugar syntax
    # in this case it will help you with Array class for the following
    #
    #   Array.__send__ :include/:extend , ::MPatch::Module::Name
    #
    # it will always choose include or extend method based on the module use porpuse
    # now it's a :include

    MPatch.patch! # || inject_patches || inject
    puts ["asd"].has_any_of?(%W[ 123 hello\ world sup? asd ])
```

## make your own!

you can make your own monkey patches by the following

```ruby
  module MPatch

    module Include # if you want to include to the target object

      module TargetClassName #> for example Array

      end

    end

  end

  MPatch.patch!
  # done, you all set
  # if you want to contribute with use cases, please do so! :)
```

But there is a lot of method, for example for modules modules / subbmodules call that retunr modules under that namespace.
Lot of metaprogrammer stuff there too :)

please do enjoy :)
