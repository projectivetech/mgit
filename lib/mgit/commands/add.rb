module MGit
  class AddCommand < Command
    def execute(args)
      path = File.expand_path(args[0])
      fail CommandUsageError.new('First argument must be a path to a directory.', self) unless File.directory?(path)
      fail CommandUsageError.new('First argument must be a path to a git repository.', self) unless git_dir?(path)
      fail CommandUsageError.new('Sorry, mgit can not handle bare repositories.', self) if bare?(path)

      name = (args.size == 2) ? args[1] : File.basename(path)
      fail CommandUsageError.new("Repository named #{name} already exists with different path.", self) unless new_or_same?(name, path)

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

    def new_or_same?(name, path)
      repo = Registry.find { |r| r.name == name }
      repo.nil? || repo.path == path
    end

    def git_dir?(path)
      System.git('status', chdir: path) !~ /fatal: Not a git repository/
    end

    def bare?(path)
      System.git('status', chdir: path) =~ /fatal: This operation must be run in a work tree/
    end
  end
end
