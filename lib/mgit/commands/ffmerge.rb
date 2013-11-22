module MGit
  class FFMergeCommand < Command
    def execute(args)
      Registry.chdir_each do |repo|

        bs = repo.remote_tracking_branches.select do |branch, upstream|
          !repo.unmerged_commits(branch, upstream).empty?
        end.map { |b, u| b }

        next if bs.empty?

        if repo.dirty?
          pwarn "Skipping repository #{repo.name} since it's dirty."
          next
        end 

        pinfo "Fast-forward merging branches in repository #{repo.name}..."

        cb = repo.current_branch
        bs.each do |b|
          `git checkout -q #{b}`
          `git merge --ff-only @{u}`
        end
        `git checkout -q #{cb}`
      end
    end

    def arity
      [nil, 0]
    end

    def usage
      'ffmerge'
    end

    def description
      'merge all upstream tracking branches that can be fast-forwarded'
    end

    register_command :ffmerge
  end
end
