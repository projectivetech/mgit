module MGit
  class CLI
    def start
      raise NoCommandError if ARGV.size == 0
      command = Command.create(ARGV.shift.downcase.to_sym)
      command.execute(ARGV)
    end
  end
end
