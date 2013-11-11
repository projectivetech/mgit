module MGit
  class AddCommand < Command
    def execute(args)
      path = File.expand_path(args[0])
      raise CommandUsageError.new('First argument must be a path to a git repository.', self) unless is_git_dir?(path)

      name = (args.size == 2) ? args[1] : (ask('Name of the repository? ') { |q| q.default = File.basename(path) })
      raise CommandUsageError.new("Repository named #{name} already exists with different path.", self) unless is_new_or_same?(name, path)
      
      Registry.add(name, path)
    end

    def arity
      [1, 2]
    end

    def usage
      'add <path_to_git_repository> [name]'
    end

    def description
      'add a repository to mgit'
    end

    register_command :add

  private

    def is_new_or_same?(name, path)
      repo = Registry.find { |r| r.name == name }
      repo.nil? || repo.path == path
    end

    def is_git_dir?(path)
      File.directory?(path) && (File.directory?(File.join(path, '.git')) || File.file?(File.join(path, 'HEAD')))
    end
  end
end
