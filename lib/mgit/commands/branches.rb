module MGit
  class BranchesCommand < Command
    def execute(args)
      Registry.each do |repo|
        pinfo "Repository #{repo.name} contains branches:"
        repo.branches.each do |b|
          psystem "#{b[:name]} #{b[:current] ? '*' : ''}"
        end
      end
    end

    def arity
      [nil, 0]
    end

    def usage
      'branches'
    end

    def description
      'list all repository branches and tracked upstream branches'
    end

    register_command :branches
  end
end
