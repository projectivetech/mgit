module MGit
  class ListCommand < Command
    def execute(args)
      t = []
      Registry.each { |repo| t << [repo.name, repo.path] }
      ptable t, :columns => [24, nil]
    end

    def arity
      [nil, 0]
    end

    def usage
      'list'
    end

    def description
      'list all repositories'
    end

    register_command :list
    register_alias :ls
  end
end
