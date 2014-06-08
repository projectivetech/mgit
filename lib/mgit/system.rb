require 'open3'

module MGit
  module System
    class SystemCommand
      include Output

      attr_reader :stdout, :stderr

      def initialize(cmd, opts)
        opts, popen_opts = extract_options(opts)
        @stdout, @stderr, @st = Open3.capture3(cmd, popen_opts)

        psystem(stdout.strip) if opts[:print_stdout]

        return if success?

        psystem(stderr.strip) if opts[:print_stderr]
        fail SystemCommandError.new(cmd, opts[:error]) if opts[:raise]
      end

      def success?
        @st.exitstatus == 0
      end

      def =~(other)
        (@stdout =~ other) || (@stderr =~ other)
      end

      def default_options
        {
          print_stdout: false,
          print_stderr: false,
          raise: false,
          error: 'Command failed.'
        }
      end

      def extract_options(opts)
        popen_opts = opts.dup

        opts = Hash[
          default_options.map do |k, v|
            [k, popen_opts.key?(k) ? popen_opts.delete(k) : v]
          end
        ]

        [opts, popen_opts]
      end
    end

    class GitCommand < SystemCommand
      def initialize(cmd, opts)
        super("git #{cmd}", opts)
      rescue SystemCommandError => e
        raise GitError, e.error
      end
    end

    def self.git(cmd, opts = {})
      GitCommand.new(cmd, opts)
    end

    def self.run(cmd, opts = {})
      SystemCommand.new(cmd, opts)
    end
  end
end
