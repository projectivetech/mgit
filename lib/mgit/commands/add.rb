module MGit
  class AddCommand < Command
    def execute(args)
      path = File.expand_path(args[0])
      raise CommandUsageError.new('First argument must be a path to a directory.', self) unless File.directory?(path)
      raise CommandUsageError.new('First argument must be a path to a git repository.', self) unless is_git_dir?(path)
      raise CommandUsageError.new('Sorry, mgit can not handle bare repositories.', self) if is_bare?(path)

      # NOTE: The to_s to the HighLine::String is needed due to a bug in YAML/Psych in Ruby 2.0.0.
      # https://github.com/JEG2/highline/issues/69
      name = (args.size == 2) ? args[1] : (ask('Name of the repository? ') { |q| q.default = File.basename(path) }).to_s
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
      Dir.chdir(path) { `git status 2>&1` !~ /fatal: Not a git repository/ }
    end

    def is_bare?(path)
      Dir.chdir(path) { `git status 2>&1` =~ /fatal: This operation must be run in a work tree/}
    end
  end
end
