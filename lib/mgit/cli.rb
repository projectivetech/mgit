module MGit
  class CLI
    include Output

    def start
      raise NoCommandError if ARGV.size == 0
      command = Command.execute(ARGV.shift, ARGV)
    rescue UsageError => e
      perror e.to_s
    rescue GitError => e
      perror e.to_s
    end
  end
end
