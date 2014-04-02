module MGit
  class ConfigCommand < Command
    def execute(args)
      if args.size == 0
        t = []
        Configuration.each { |k, v| t << [k.to_s, v] }
        ptable t
      else
        key = args[0]

        if args.size == 1
          psystem Configuration.send(key.to_sym).to_s
        else
          key = args[0]
          value = args[1]

          begin
            Configuration.set(key, value)
          rescue ConfigurationError => e
            raise CommandUsageError.new(e.to_s, self)
          end
        end
      end
    end

    def arity
      [0, 2]
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
