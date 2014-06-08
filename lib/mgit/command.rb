module MGit
  class Command
    include Output

    @@commands = {}
    @@aliases = {}

    def self.load_commands
      require_commands_from_directory File.expand_path('../commands', __FILE__)
      require_commands_from_directory Configuration.plugindir
    end

    def self.execute(name, args)
      cmd = create(name)
      cmd.check_arity(args)
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

    def check_arity(args)
      arity_min, arity_max = arity
      fail TooFewArgumentsError, self if arity_min && args.size < arity_min
      fail TooManyArgumentsError, self if arity_max && args.size > arity_max
    end

    [:arity, :usage, :help, :description].each do |meth|
      define_method(meth) do
        fail ImplementationError, "Command #{self.class.name} doesn't implement the #{meth} method."
      end
    end

    def self.create(cmd)
      cmd = cmd.downcase.to_sym
      klass = @@commands[cmd] || @@aliases[cmd]
      if klass
        klass.new
      else
        fail UnknownCommandError, cmd
      end
    end

    def self.require_commands_from_directory(dir)
      Dir["#{dir}/*.rb"].each { |file| require file }
    end
  end
end
