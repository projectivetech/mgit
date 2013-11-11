module MGit
  class RemoveCommand < Command
    def execute(args)
      ptrn = args[0]

      repo = Registry.find do |repo|
        repo.name == ptrn || repo.path == File.expand_path(ptrn)
      end
      
      raise CommandUsageError.new("Couldn't find repository matching '#{ptrn}'.", self) unless repo

      Registry.remove(repo.name)
      pinfo "Removed repository #{repo.name}."
    end

    def arity
      [1, 1]
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
