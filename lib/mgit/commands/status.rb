require 'set'

module MGit
  class StatusCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Repository.chdir_each do |name, path|
        nc = 36
        display = (name.size > nc) ? (name[0..(nc - 3)] + '...') : name.ljust(nc, ' ')
        puts "#{display} => [#{flags.to_a.join(', ')}]"
      end
    end

    def usage
      'status'
    end

    def description
      'display status for each repositories'
    end

    register_command :status
    register_alias :st

  private

    def flags
      flags = Set.new
      status = `git status --short --branch --ignore-submodules`.split("\n")
      status.each do |s|
        case s.split[0]
        when 'A'
          flags << 'Index'.red
        when 'M'
          flags << 'Dirty'.red
        when '??'
          flags << 'Untracked'.yellow
        when '##'
          if(m = /## ([\w,\/]+)\.\.\.([\w,\/]+) \[(\w+) (\d+)\]/.match(s))
            flags << "#{m[3].capitalize} of #{m[2]} by #{m[4]}".blue
          end
        end
      end

      flags.empty? ? ['Clean'.green] : flags
    end
  end
end
