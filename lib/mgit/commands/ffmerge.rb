module MGit
  class FFMergeCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Repository.chdir_each do |name, path|
        if dirty?
          puts "Skipping repository #{name} since its "

        tb = tracking_branches
        cb = current_branch

        tb.each do |b|
          `git checkout 
        puts "Looking for pattern '#{ptrn}' in repository #{name}...".yellow
        puts `git grep #{ptrn}`
        puts
      end
    end

    def usage
      'ffmerge'
    end

    def description
      'merge all upstream tracking branches that can be fast-forwarded'
    end

    register_command :ffmerge

  private

    def dirty?
      `git diff --shortstat | tail -n 1` != ''
    end

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
