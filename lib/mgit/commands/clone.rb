module MGit
  class CloneCommand < Command
    def execute(args)
      log = System.git("clone #{args.join(' ')}", raise: true)

      m = [log.stdout, log.stderr].find do |l|
        f = l.split("\n").first
        f && f.start_with?('Cloning into')
      end

      d = /Cloning into '(.*)'/.match(m)
      fail 'Failed to determine repository directory.' unless d

      Command.execute('add', [d[1]])
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
  end
end
