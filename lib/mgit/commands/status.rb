require 'set'

module MGit
  class StatusCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Registry.chdir_each do |repo|
        nc = 36
        display = (repo.name.size > nc) ? (repo.name[0..(nc - 3)] + '...') : repo.name.ljust(nc, ' ')
        puts "#{display} => [#{flags(repo).to_a.join(', ')}]"
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

    def flags(repo)
      flags = []

      fs = repo.flags
      flags << 'Index'.red if fs.include?(:index)
      flags << 'Dirty'.red if fs.include?(:dirty)
      flags << 'Untracked'.yellow if fs.include?(:untracked)
      flags << 'Detached'.yellow if fs.include?(:detached)

      if fs.include?(:diverged)
        ds = repo.divergence
        ds.each do |d|
          flags << "#{d.first[0].to_s.capitalize} of #{d.first[1][:branch]} by #{d.first[1][:by]}".blue
        end
      end

      if flags.empty?
        flags << 'Clean'.green
      end

      flags
    end
  end
end
