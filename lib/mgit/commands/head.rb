module MGit
  class HeadCommand < Command
    def execute(_)
      t = []
      Registry.each { |repo| t << [repo.name, repo.current_branch, repo.current_head] }
      ptable t, columns: [24, nil, nil]
    end

    def arity
      [0, 0]
    end

    def usage
      'head'
    end

    def description
      'show repository HEADs'
    end

    register_command :head
  end
end
