require 'set'

module MGit
  class Repository
    include Output

    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def available?
      unless File.directory?(path)
        pwarn "Repository #{name} is not available anymore. Failed to read #{path}."
        return false
      end

      true
    end

    def current_branch
      in_repo do
        sc = System.git('rev-parse --abbrev-ref HEAD')
        sc.success? ? sc.stdout.strip : 'HEAD'
      end
    end

    def current_head
      in_repo { System.git('rev-parse --verify --short HEAD').stdout.strip }
    end

    def branches
      in_repo do
        System.git('branch --no-color')
          .stdout
          .strip
          .split("\n")
          .map { |b| b.split(' ') }
          .map { |b| { name: b.last, current: (b.size == 2) } }
      end
    end

    def remote_tracking_branches(upstream_exists_only = true)
      rb = remote_branches

      a = in_repo do
        System.git("for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads")
          .stdout
          .split("\n")
          .map { |b| b.split(' ') }
          .reject { |b| b.size != 2 }
          .select { |b| !upstream_exists_only || rb.include?(b[1]) }
      end

      Hash[a]
    end

    def remote_branches
      in_repo do
        System.git('branch -r').stdout.split("\n").map { |a| a.split(' ')[0] }
      end
    end

    def unmerged_commits(branch, upstream)
      in_repo do
        System.git("log --pretty=format:'%h#%an#%s' --reverse  --relative-date #{branch}..#{upstream}")
          .stdout
          .split("\n")
          .map { |line| line.split('#') }
          .map do |words|
            {
              commit: words[0],
              author: words[1],
              subject: words[2..-1].join('#')
            }
          end
      end
    end

    SIMPLE_FLAGS = { 'A' => :index, 'M' => :dirty, '??' => :untracked }

    def flags
      flags = Set.new
      status_lines do |s|
        indicator = s.split[0]

        case indicator
        when *SIMPLE_FLAGS.keys
          flags << SIMPLE_FLAGS[indicator]
        when '##'
          if %r{## [\w,/]+\.\.\.[\w,/]+ \[.+\]} =~ s
            flags << :diverged
          elsif /## HEAD \(no branch\)/ =~ s
            flags << :detached
          end
        end
      end

      flags
    end

    def divergence
      divergence = []
      status_lines do |s|
        if s.split[0] == '##'
          if (m = %r{## ([\w,/]+)\.\.\.([\w,/]+) \[ahead (\d+), behind (\d+)\]}.match(s))
            divergence << { ahead: { branch: m[2], by: m[3] }, behind: { branch: m[2], by: m[4] } }
          elsif (m = %r{## ([\w,/]+)\.\.\.([\w,/]+) \[(\w+) (\d+)\]}.match(s))
            if m[3] =~ /behind/
              divergence << { behind: { branch: m[2], by: m[4] } }
            else
              divergence << { ahead: { branch: m[2], by: m[4] } }
            end
          end
        end
      end
      divergence
    end

    def dirty?
      [:index, :dirty].any? { |f| flags.include?(f) }
    end

    def in_repo
      Dir.chdir(path) { yield }
    end

    alias_method :chdir, :in_repo

    private

    def status
      @status ||= in_repo { System.git('status --short --branch --ignore-submodules').stdout.split("\n") }
    end

    def status_lines
      status.each { |s| yield s }
    end
  end
end
