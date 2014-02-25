$DEBUG= true

require 'fileutils'
require 'debugger'


Dir.glob(File.join(Dir.pwd,'lib','mpatch',"*.{rb,ru}")).each do |file_path|

  File.open(file_path,"r") do |file|

    namespace= nil
    folder_path= file_path.split(File::Separator)
    file_name= folder_path.pop
    folder_path.push file_name.split('.')[0]
    folder_path= folder_path.join(File::Separator)
    #FileUtils.mkpath folder_path unless File.exists?(folder_path)

    array_of_line = [ ]
    block_open    =  0
    comments      = [ ]

    file.read.each_line do |file_line|
      file_line.split(';').each do |line|



        method_name= nil

        #if line.include? "map_hash_obj.each do |hash|"
        #  debugger
        #end


        %w[ class module ].each do |block_opener|

          if line.scan(/^\s*#/).empty?

            if !line.scan(/^\s*\b#{block_opener}\b\s*\w/).empty?

              namespace ||= line

              puts "(#{block_open}) + for #{line}" if $DEBUG
              block_open += 1
              break
            end

          end
        end

        tmp_end= false
        %w[ if case while until unless def do begin ].each do |block_opener|

          if line.scan(/^\s*#/).empty?

            if line.scan(/\bend\b/).empty?
              if !line.scan(/\s*\w*\b#{block_opener}\b/).empty?

                unless line.include? "&&"

                  puts "(#{block_open}) + for #{line}" if $DEBUG
                  block_open += 1
                  break


                end

              end
            end

          end
        end


        if !line.scan(/^\s*#/).empty?
          comments.push line
        end

        #if block_open > 1 && line.include?("def")
        #  puts line
        #end

        if block_open >= 2
          array_of_line.push line
        end


        if line.scan(/^\s*#/).empty?
          if !line.scan(/\bend\b/).empty?

            puts "(#{block_open}) - for #{line}" if $DEBUG
            block_open -= 1

          end
        end


        if !array_of_line.empty? && block_open == 0

          #puts array_of_line,"---"

          #tmp_array = Array.new
          #tmp_array.push namespace
          #tmp_array += comments
          #tmp_array += array_of_line
          #tmp_array.push "end"
          #
          #File.new(File.join(folder_path,method_name.to_s+".rb"),"w").write(tmp_array.join())


          array_of_line.clear
          comments.clear

        end

      end
    end
  end
end