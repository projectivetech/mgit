module MGit
  class CLI
    def start
      raise NoCommandError if ARGV.size == 0
      command = Command.execute(ARGV.shift, ARGV)
    rescue UsageError => e
      $stderr.puts e
    end
  end
end
