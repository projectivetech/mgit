module MGit
  class CloneCommand < Command
    def execute(args)
      log = System.git("clone #{args.join(' ')}", raise: true)
      
      m = [log.stdout, log.stderr].find do |l|
        /Cloning into '(.*)'/.match(l.split("\n").first)
      end

      fail 'Failed to determine repository directory.' unless m
      
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
