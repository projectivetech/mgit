module MGit
  class CLI
    include Output

    def start
      fail NoCommandError if ARGV.size == 0

      MGit.init

      # Run command, consuming its name from the list of arguments.
      Command.execute(ARGV.shift, ARGV)
    rescue UsageError => e
      perror e.to_s
    rescue GitError => e
      perror e.to_s
    end
  end
end
