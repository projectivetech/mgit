module MGit
  class AddCommand < Command
    def execute(args)
      raise TooFewArgumentsError if args.size == 0
      raise TooManyArgumentsError if args.size > 2

      path = File.expand_path(args[0])
      raise CommandArgumentError.new('first argument must be a path to a git repository') unless is_git_dir?(path)

      name = (args.size == 2) ? args[1] : (ask('Name of the repository? ') { |q| q.default = File.basename(path) })

      Repository.add(name, path)
    end

    register_command :add

  private

    def is_git_dir?(path)
      File.directory?(path) && (File.directory?(File.join(path, '.git')) || File.file?(File.join(path, 'HEAD')))
    end
  end
end
