require 'set'

module MGit
  class StatusCommand < Command
    def execute(args)
      t = []
      Registry.chdir_each { |repo| t << [repo.name, repo.current_branch, flags(repo).to_a.join(', ')] }
      ptable t, :columns => [24, nil, nil]
    end

    def arity
      [nil, 0]
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
