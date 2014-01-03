require 'set'

module MGit
  class StatisticsCommand < Command
    def execute(args)
      total_authors = {}
      total_punchcard = {}
      Registry.chdir_each do |repo|
        current_authors = {}
        current_punchcard = {}

        collect do |author, time, changes|
          current_authors[author] ||= 0
          current_authors[author] += changes

          total_punchcard[time.wday] ||= {}
          total_punchcard[time.wday][time.hour / 4] ||= 0
          total_punchcard[time.wday][time.hour / 4] += changes
        end

        print_authors current_authors, repo.name
        puts

        current_authors.each do |author, changes|
          total_authors[author] ||= 0
          total_authors[author] += changes
        end
      end

      print_authors total_authors, 'TOTAL'
      puts
      print_punchcard total_punchcard, 'TOTAL'
    end

    def arity
      [nil, 0]
    end

    def usage
      'statistics'
    end

    def description
      'display authorship statistics for each repository and in total'
    end

    register_command :statistics

    # Too close to :status?
    #register_alias :stats

  private

    def collect
      log = `git log --format='<><>%ct %aN' --shortstat --all`.strip
      commits = log.split('<><>').drop(1)

      commits.each do |c|
        lines = c.split("\n")
        
        time = lines[0].split(' ')[0]
        author = lines[0].split(' ')[1..-1].join(' ')

        if lines.size >= 3
          m = /changed(?:, (\d+) insertion(?:s)?\(\+\))?(?:, (\d+) deletion(?:s)?\(\-\))?/.match(lines[2])
          changes = (m.captures[0] || 0).to_i + (m.captures[1] || 0).to_i
        else
          changes = 0
        end

        yield author, Time.at(time.to_i), changes
      end
    end

    def print_authors(data, name)
      pinfo "Authorship statistics (#{name}):"
      ptable (data.to_a.sort_by { |v| v[1] }.reverse), :columns => [24, nil]
    end

    def print_punchcard(data, name)
      pinfo "Punchcard (#{name}):"

      t = []
      t << ['', '0-4', '4-8', '8-12', '12-16', '16-20', '20-24']
      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].each_with_index do |day, wday|
        l = [day]
        6.times do |h|
          if (data[wday] && data[wday][h])
            l << data[wday][h].to_s
          else
            l << '0'
          end
        end
        t << l
      end

      ptable t
    end
  end
end
