module MGit
  class LogCommand < Command
    def execute(args)
      Registry.chdir_each do |repo|
        repo.remote_tracking_branches.each do |branch, upstream|
          uc = repo.unmerged_commits(branch, upstream)
          next if uc.empty?

          pinfo "In repository #{repo.name}, branch #{upstream} the following commits were made:"
          
          t = []
          uc.each { |c| t << [c[:commit], c[:author], c[:subject]] }
          ptable t
        end
      end
    end

    def arity
      [nil, 0]
    end

    def usage
      'log'
    end

    def description
      'show unmerged commits for all remote-tracking branches'
    end

    register_command :log
  end
end
