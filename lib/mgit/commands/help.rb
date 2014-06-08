module MGit
  class HelpCommand < Command
    def execute(args)
      if args.size == 0
        pinfo 'M[eta]Git - manage multiple git repositories at the same time'
        pinfo ''
        pinfo 'Usage:'
        Command.instance_each do |cmd|
          pinfo "mgit #{cmd.usage}"
          pinfo "\t- #{cmd.description}"
        end
      else
        pinfo Command.create(args[0]).help
      end
    end

    def arity
      [0, 1]
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
