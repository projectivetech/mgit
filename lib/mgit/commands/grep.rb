module MGit
  class GrepCommand < Command
    def execute(args)
      ptrn = args[0]

      Registry.chdir_each do |repo|
        pinfo "Looking for pattern '#{ptrn}' in repository #{repo.name}..."
        puts `git grep #{ptrn}`
        puts
      end
    end

    def arity
      [1, 1]
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
