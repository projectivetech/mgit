module MGit
  class HelpCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size > 1

      if args.size == 0
        puts "M[eta]Git - manage multiple git repositories at the same time"
        puts
        puts "Usage:"
        Command.instance_each do |cmd|
          puts "mgit #{cmd.usage}\n\t- #{cmd.description}"
        end
      else
        puts Command.create(args[0]).help
      end
    end

    def usage
      'help [command]'
    end

    def description
      'display help information'
    end

    register_command :help
  end
end
