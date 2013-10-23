module MGit
  class Command
    @@commands = {}
    @@aliases = {}

    def self.create(cmd)
      c = @@commands[cmd] || @@aliases[cmd]
      if c
        c.new
      else
        raise UnknownCommandError.new(cmd)
      end
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
  end
end
