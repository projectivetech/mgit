module MGit
  class FetchCommand < Command
    def execute(args)
      Registry.chdir_each do |repo|
        `git remote`.split.each do |remote|
          puts "Fetching #{remote} in repository #{repo.name}...".yellow
          `git fetch #{remote}`
        end
      end
    end

    def arity
      [nil, 0]
    end

    def usage
      'fetch'
    end

    def description
      'fetch all remote repositories'
    end

    register_command :fetch
  end
end
