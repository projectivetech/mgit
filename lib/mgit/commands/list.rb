module MGit
  class ListCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Repository.each do |name, path|
        puts "#{name} => #{path}"
      end
    end

    def usage
      'list'
    end

    register_command :list
    register_alias :ls
  end
end
