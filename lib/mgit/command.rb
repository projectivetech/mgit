module MGit
  class Command
    @@commands = {}
    @@aliases = {}

    def self.create(cmd)
      c = @@commands[cmd] || @@aliases[cmd]
      if c
        c.new
      else
        raise UnknownCommandError
      end
    end

    def self.register_command(cmd)
      @@commands[cmd] = self
    end

    def self.register_alias(cmd)
      @@aliases[cmd] = self
    end
  end
end
