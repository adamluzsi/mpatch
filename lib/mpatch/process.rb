module Process

  # return a string obj that include the memory usage info
  def self.memory_usage

    begin
      return `pmap #{Process.pid}`.lines.to_a(
      ).last.chomp.scan(/ *\w* *(\w+)/)[0][0]
    rescue NoMethodError
      return nil
    end

  end


  def self.daemonize
    File.create Application.pid,'a+'
    File.create Application.log,'a+'
    File.create Application.daemon_stderr,'a+'
    Daemon.start fork,
                 Application.pid,
                 Application.log,
                 Application.daemon_stderr
  end
  def self.stop
    Daemon.stop
  end
end