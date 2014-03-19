module MPatch
  module Process

    # return a string obj that include the memory usage info
    def self.memory_usage

      begin
        return `pmap #{self.pid}`.lines.to_a(
        ).last.chomp.scan(/ *\w* *(\w+)/)[0][0]
      rescue ::NoMethodError
        return nil
      end

    end

  end
end