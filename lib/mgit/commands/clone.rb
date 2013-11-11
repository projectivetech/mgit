module MGit
  class CloneCommand < Command
    def execute(args)
      log = `git clone #{args.join(' ')}`
      raise GitError.new('Clone command failed.') if $?.exitstatus != 0

      m = /Cloning into '(.*)'/.match(log.split("\n").first)
      Command.execute('add', [m[1]])
    end

    def arity
      [1, nil]
    end

    def usage
      'clone [options] <url> [<directory>]'
    end

    def description
      'clone repository and add to mgit'
    end

    register_command :clone

  private

    def option?(arg)
      arg.start_with?('-')
    end
  end
end
