module MGit
  class ListCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Registry.each do |repo|
        puts "#{repo.name} => #{repo.path}"
      end
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
