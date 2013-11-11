module MGit
  class ForEachCommand < Command
    def execute(args)
      command = args.join(' ')

      Registry.chdir_each do |repo|
        pinfo "Executing command in repository #{repo.name}..."
        if !system(command) && !ask("Executing command '#{command}' in repository '#{repo.name}' failed. Would you like to continue anyway?".red)
          break
        end
      end
    end

    def arity
      [1, nil]
    end

    def usage
      'foreach <command...>'
    end

    def description
      'execute a command for each repository'
    end

    register_command :foreach
  end
end
