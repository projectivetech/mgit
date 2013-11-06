module MGit
  class LogCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size > 1

      days = 1

      if args.size == 1
        begin
          days = Integer(args[0])
        rescue ArgumentError => e
          raise new CommandUsageError("First argument must be an integer", self)
        end
      end

      Registry.chdir_each do |repo|
        lc = latest_commits(days)#.sort_by { |c| c[:author] }
        next if lc.empty?

        puts "In repository #{repo.name} the following commits were made:".yellow

        longest_name = lc.map { |c| c[:author].size }.max

        lc.each do |c|
          puts "#{c[:commit]}  #{c[:author].ljust(longest_name, ' ')}  #{c[:subject]}"
        end
        puts
      end
    end

    def usage
      'log [number_of_days]'
    end

    def description
      'what happened since *n* days ago'
    end

    register_command :log

  private

    def latest_commits(days)
      `git log --pretty=format:"%h#%an#%s" --reverse --all --since=#{days}.days.ago --relative-date`.
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
