require 'open3'

module MGit
  class FetchCommand < Command
    def execute(_)
      thread_class = Configuration.threads ? Thread : NullThread

      threads = Registry.map do |repo|
        thread_class.new { fetch(repo) }
      end

      threads.each { |t| t.join }
    end

    def arity
      [nil, 0]
    end

    def usage
      'fetch'
    end

    def description
      'fetch all remote repositories'
    end

    register_command :fetch

    private

    def prune_switch
      Configuration.prune ? '--prune' : ''
    end

    def fetch(repo)
      sc = System.git('remote', chdir: repo.path)

      unless sc.success?
        perror "Failed to read remotes for repository #{repo.name}! Abort."
        return
      end

      sc.stdout.strip.split.each do |remote|
        if System.git("fetch #{prune_switch} #{remote}", chdir: repo.path).success?
          pinfo "Fetched #{remote} in repository #{repo.name}."
        else
          perror "Failed to fetch #{remote} in repository #{repo.name}! Abort."
          break
        end
      end
    end

    class NullThread
      def initialize
        yield
      end

      def join
      end
    end
  end
end
