module MGit
  class FFMergeCommand < Command
    def execute(args)
      Registry.chdir_each do |repo|
        branches = mergable_branches(repo)
        next if branches.empty?

        if repo.dirty?
          pwarn "Skipping repository #{repo.name} since it's dirty."
          next
        end

        merge_branches(repo, branches)
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

  private

    def mergable_branches(repo)
      repo.remote_tracking_branches.select do |branch, upstream|
        !repo.unmerged_commits(branch, upstream).empty?
      end.map { |b, u| b }
    end

    def merge_branches(repo, branches)
      pinfo "Fast-forward merging branches in repository #{repo.name}..."

      cb = repo.current_branch

      begin
        branches.each { |b| merge_branch(b) }
      rescue GitError
        perror "Failed to merge a branch in repository #{repo.name}."
        pwarn "Please visit this repository and check that everything's alright. Trying to set back to original working branch."
      ensure
        System::git("checkout -q #{cb}", :print_stderr => true)
      end
    end

    def merge_branch(branch)
      System::git("checkout -q #{branch}", { :raise => true, :print_stderr => true })
      System::git("merge --ff-only @{u}", { :raise => true, :print_stderr => true })
    end
  end
end
