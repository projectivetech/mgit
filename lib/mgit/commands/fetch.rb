require 'open3'

module MGit
  class FetchCommand < Command
    def execute(args)
      thread_class = Configuration.threads ? Thread : NullThread
      threads = []
      Registry.each do |repo|
        threads << thread_class.new do
          fetch(repo)
        end
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

    def fetch(repo)
      remotes, st = Open3.capture2('git remote', :chdir => repo.path)

      if st.exitstatus != 0
        perror "Failed to read remotes for repository #{repo.name}! Abort."
        Thread.exit
      end

      remotes.split.each do |remote|
        sout, st = Open3.capture2("git fetch #{remote}", :chdir => repo.path)
        if st.exitstatus == 0
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
