module MGit
  class UsageError < StandardError
    def initialize(error, usage)
      @error = error
      @usage = usage
    end

    def to_s
      @error + "\n" + @usage
    end
  end

  class NoCommandError < UsageError
    def initialize
      super('No commands given.', 'Usage: mgit <command> [parameters]')
    end
  end

  class UnknownCommandError < UsageError
    def initialize(cmd)
      super("Unknown command '#{cmd}'.", "Command may be one of: #{Command.list}")
    end
  end

  class CommandUsageError < UsageError
    def initialize(error, cmd)
      super(error, "Usage: mgit #{cmd.usage}")
    end
  end

  class TooFewArgumentsError < CommandUsageError
    def initialize(cmd)
      super('Too few arguments.', cmd)
    end
  end

  class TooManyArgumentsError < CommandUsageError
    def initialize(cmd)
      super('Too many arguments.', cmd)
    end
  end
end
