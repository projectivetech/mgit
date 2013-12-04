module MGit
  class Command
    include Output

    @@commands = {}

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

    self.singleton_class.send(:alias_method, :register_alias, :register_command)

    def self.list
      '[' + @@commands.keys.join(', ') + ']'
    end

    def self.instance_each
      @@commands.each do |_, klass|
        yield klass.new
      end
    end

    [:arity, :usage, :help, :description].each do |meth|
      define_method(meth) do
        raise ImplementationError.new("Command #{self.class.name} doesn't implement the #{meth.to_s} method.")
      end
    end

  private

    def self.create(cmd)
      cmd = cmd.downcase.to_sym
      klass = @@commands[cmd]
      if klass
        klass.new
      else
        raise UnknownCommandError.new(cmd)
      end
    end
  end
end
