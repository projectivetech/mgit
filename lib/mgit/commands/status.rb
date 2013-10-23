module MGit
  class StatusCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      repos = Repository.all

      repos.each do |name, path|
        git_status = Dir.chdir(path) { `git status --short` }
        puts "#{name} => #{git_status}"
      end
    end

    def usage
      'status'
    end

    register_command :status
    register_alias :st
  end
end
