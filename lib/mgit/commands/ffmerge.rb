module MGit
  class FFMergeCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Registry.chdir_each do |repo|
        if repo.dirty?
          puts "Skipping repository #{repo.name} since it's dirty.".red
          next
        end 

        puts "Fast-forward merging branches in repository #{repo.name}...".yellow

        cb = repo.current_branch
        repo.remote_tracking_branches.each do |b, u|
          `git checkout -q #{b}`
          `git merge --ff-only @{u}`
        end
        `git checkout -q #{cb}`
      end
    end

    def usage
      'ffmerge'
    end

    def description
      'merge all upstream tracking branches that can be fast-forwardeded'
    end

    register_command :ffmerge
  end
end
