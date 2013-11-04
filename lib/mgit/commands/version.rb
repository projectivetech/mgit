module MGit
  class VersionCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0
      puts "mgit version #{MGit::VERSION}"
    end

    def usage
      'version'
    end

    def description
      'display mgit version'
    end

    register_command :version 
  end
end
