module MGit
  class TagsCommand < Command
    def execute(args)
      t = []
      Registry.chdir_each { |repo| t << [repo.name, *latest_tag] }
      ptable t, :columns => [24, nil, nil]
    end

    def arity
      [0, 0]
    end

    def usage
      'tags'
    end

    def description
      'display the latest tag in repository'
    end

    register_command :tags

  private

    def latest_tag
      sha = `git rev-list --tags --max-count=1 2>&1`.strip
      sha =~ /usage:/ ? ['none', ''] : print_tag(sha)
    end

    def print_tag(sha)
      [
        `git describe #{sha}`.strip,
        Time.at(`git log -n 1 --format="%at" #{sha}`.strip.to_i).strftime('%Y-%m-%d')
      ]
    end
  end
end
