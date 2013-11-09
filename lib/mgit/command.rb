module MGit
  class Command
    @@commands = {}
    @@aliases = {}

    def self.execute(name, args)
      cmd = self.create(name)

      arity_min, arity_max = cmd.arity
      raise TooFewArgumentsError.new(cmd) if arity_min && args.size < arity_min
      raise TooManyArgumentsError.new(cmd) if arity_max && args.size > arity_max

      cmd.execute(args)
    end

    def self.register_command(cmd)
      @@commands[cmd] = self
    end

    def self.register_alias(cmd)
      @@aliases[cmd] = self
    end

    def self.list
      '[' + @@commands.keys.join(', ') + ']'
    end

    def self.instance_each
      @@commands.each do |_, klass|
        yield klass.new
      end
    end

    def arity
      raise ImplementationError.new("Command #{self.class.name} doesn't implement the arity method.")
    end

    def usage
      raise ImplementationError.new("Command #{self.class.name} doesn't implement the usage method.")
    end

    def help
      raise ImplementationError.new("Command #{self.class.name} doesn't implement the help method.")
    end

    def description
      raise ImplementationError.new("Command #{self.class.name} doesn't implement the description method.")
    end

  private

    def self.create(cmd)
      cmd = cmd.downcase.to_sym
      klass = @@commands[cmd] || @@aliases[cmd]
      if klass
        klass.new
      else
        raise UnknownCommandError.new(cmd)
      end
    end
  end
end
