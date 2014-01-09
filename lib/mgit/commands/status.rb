require 'set'

module MGit
  class StatusCommand < Command
    def execute(args)
      t = []
      Registry.chdir_each { |repo| t << [repo.name, repo.current_branch, decorate_flags(repo)] }
      ptable t, :columns => [24, nil, nil]
    end

    def arity
      [nil, 0]
    end

    def usage
      'status'
    end

    def description
      'display status for each repository'
    end

    register_command :status
    register_alias :st

  private

    def decorate_flags(repo)
      flags = repo.flags
      labels = decorate_simple_flags(flags)
      labels.concat(decorate_divergence_flags(repo.divergence)) if flags.include?(:diverged)
      labels = ['Clean'.green] if labels.empty?
      labels.to_a.join(', ')
    end

    def decorate_simple_flags(flags)
      { :index => :red, :dirty => :red, :untracked => :yellow, :detached => :yellow }
        .select { |f,_| flags.include?(f) }
        .map { |f,c| f.to_s.capitalize.send(c) }
    end

    def decorate_divergence_flags(divergence)
      divergence.map do |d|
        "#{d.first[0].to_s.capitalize} of #{d.first[1][:branch]} by #{d.first[1][:by]}".blue
      end
    end
  end
end
