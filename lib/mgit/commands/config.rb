module MGit
  class ConfigCommand < Command
    def execute(args)
      key = args[0]
      value = args[1]

      Configuration.set(key, value)
    rescue ConfigurationError => e
      raise CommandUsageError.new(e.to_s, self)
    end

    def arity
      [2, 2]
    end

    def usage
      'config <key> <value>'
    end

    def description
      'configure MGit'
    end

    register_command :config
  end
end
