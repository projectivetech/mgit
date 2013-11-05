module MGit
  class ForEachCommand < Command
    def execute(args)
      raise TooFewArgumentsError.new(self) if args.size == 0

      command = args.join(' ')

      Registry.chdir_each do |name, path|
        puts "Executing command in repository #{name}...".yellow
        if !system(command) && !ask("Executing command '#{command}' in repository '#{name}' failed. Would you like to continue anyway?".red)
          break
        end
      end
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
