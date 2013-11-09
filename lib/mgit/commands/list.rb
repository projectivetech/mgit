module MGit
  class ListCommand < Command
    def execute(args)
      Registry.each do |repo|
        nc = 24
        display = (repo.name.size > nc) ? (repo.name[0..(nc - 3)] + '...') : repo.name.ljust(nc, ' ')
        puts "#{display} => #{repo.path}"
      end
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
