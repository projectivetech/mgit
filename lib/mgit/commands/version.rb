module MGit
  class VersionCommand < Command
    def execute(args)
      pinfo "mgit version #{MGit::VERSION}"
    end

    def arity
      [nil, 0]
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
