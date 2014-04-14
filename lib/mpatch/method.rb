module MPatch

  module Include

    module Method

      def get_comments

        var= self.source_location.map{|obj| obj.class <= String ? File.absolute_path(obj) : obj }

        file_obj= File.open(var[0],"r")
        file_data= [] #> [*File.open(var[0],"r")]
        var[1].times{ file_data.push file_obj.gets }
        file_data.reverse!

        desc_array= []

        first= true
        file_data.each { |new_string_line|

          if first == true
            first= false
            next
          end

          if new_string_line =~ /^[\s\t]*(#[\s\S]*)?$/

            unless new_string_line.scan(/^[\s\t]*(#\s*)([\s\S]*)?$/).empty?
              new_string_line.replace new_string_line.scan(/^[\s\t]*(#\s*)([\s\S]*)?$/)[0][1]
            end

            if new_string_line.chomp =~ /^\s*$/
              next
            end

            desc_array.push new_string_line.chomp

          else
            break
          end

        }

        #remove nils
        desc_array.compact!

        # return
        return desc_array.join("\n")

      end

    end

  end

  require File.join 'mpatch','injector'

end
