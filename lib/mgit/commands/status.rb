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

    register_command :status
    register_alias :st

  private

    def flags
      flags = Set.new
      status = `git status --short --branch --ignore-submodules`.split("\n")
      status.each do |s|
        case s.split[0]
        when 'A'
          flags << 'Index'
        when 'M'
          flags << 'Dirty'
        when '??'
          flags << 'Untracked'
        when '##'
          if(m = /## (\w+)\.\.\.([\w,\/]+) \[(\w+) (\d+)\]/.match(s))
            flags << "#{m[3].capitalize} #{m[2]} by #{m[4]}"
          end
        end
      end

      flags
    end
  end
end
