mpatch
======

Monkey patch collection for advance helper functions

This project aim to give flexible methods to the developer by giving new inheritance to the base classes

for example

```ruby

    require 'mpatch'

    class Test

      def initialize

        @hello= "world"
        @sup=   "nothing"

      end

    end

    puts Test.new.to_hash
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

    puts TargetModule.inherited_by(class).inspect
    #>[SomeClassThatInclude]

```


But there is a lot of method, for example for modules modules / subbmodules call that retunr modules under that namespace.
Lot of metaprogrammer stuff there too :)

please do enjoy :)
