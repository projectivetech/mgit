module MGit
  class LogCommand < Command
    def execute(args)
      Registry.chdir_each do |repo|
        repo.remote_tracking_branches.each do |branch, upstream|
          uc = unmerged_commits(branch, upstream)
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

  private

    def unmerged_commits(branch, upstream)
      `git log --pretty=format:"%h#%an#%s" --reverse  --relative-date #{branch}..#{upstream}`.
        split("\n").
        map { |line| line.split('#') }.
        map do |words| 
          {
            :commit => words[0],
            :author => words[1],
            :subject => words[2..-1].join('#')
          }
        end
    end
  end
end
