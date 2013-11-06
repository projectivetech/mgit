module MGit
  class GrepCommand < Command
    def execute(args)
      raise TooFewArgumentsError.new(self) if args.size == 0
      raise TooManyArgumentsError.new(self) if args.size > 1

      ptrn = args[0]

      Registry.chdir_each do |repo|
        puts "Looking for pattern '#{ptrn}' in repository #{repo.name}...".yellow
        puts `git grep #{ptrn}`
        puts
      end
    end

    def usage
      'grep <pattern>'
    end

    def description
      'grep for a pattern in each repository'
    end

    register_command :grep
  end
end
