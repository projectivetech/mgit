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

        tb = tracking_branches
        cb = current_branch
        tb.each do |b|
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

  private

    def tracking_branches
      `git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads`.
        split("\n").
        map { |b| b.split(' ') }.
        reject { |b| b.size != 2 }.
        map(&:first)
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`
    end
  end
end
