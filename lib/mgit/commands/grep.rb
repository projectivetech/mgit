module MGit
  class GrepCommand < Command
    def execute(args)
      ptrn = args[0]

      Registry.each do |repo|
        pinfo "Looking for pattern '#{ptrn}' in repository #{repo.name}..."
        System::git("grep #{ptrn}", { :chdir => repo.path, :print_stdout => true })
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
