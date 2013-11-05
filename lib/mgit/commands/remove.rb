module MGit
  class RemoveCommand < Command
    def execute(args)
      raise TooFewArgumentsError.new(self) if args.size == 0
      raise TooManyArgumentsError.new(self) if args.size > 1

      ptrn = args[0]

      repo = Registry.find do |repo|
        repo.name == ptrn || repo.path == File.expand_path(ptrn)
      end
      
      raise CommandUsageError.new("Couldn't find repository matching '#{ptrn}'.", self) unless repo

      name = repo[0]
      Repository.remove(name)
      puts "Removed repository #{name}.".yellow
    end

    def usage
      'remove <name/path>'
    end

    def description
      'remove a repository'
    end

    register_command :remove
    register_alias :rm
  end
end
