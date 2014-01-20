module MGit
  class CLI
    include Output

    def start
      raise NoCommandError if ARGV.size == 0

      # Initialize AppData and migrate if necessary.
      AppData.update

      # Initialize Commands.
      Command.load_commands

      # Run command, consuming its name from the list of arguments.
      command = Command.execute(ARGV.shift, ARGV)
    rescue UsageError => e
      perror e.to_s
    rescue GitError => e
      perror e.to_s
    end
  end
end
