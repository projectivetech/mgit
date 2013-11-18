require 'set'

module MGit
  class Repository
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def current_branch
      in_repo { 
        b = `git rev-parse --abbrev-ref HEAD 2>&1`.strip 
        $?.exitstatus == 0 ? b : 'HEAD'
      }
    end

    def remote_tracking_branches(upstream_exists_only = true)
      rb = remote_branches

      a = in_repo do
        `git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads`.
          split("\n").
          map { |b| b.split(' ') }.
          reject { |b| b.size != 2 }.
          select { |b| !upstream_exists_only || rb.include?(b[1]) }
      end
      
      Hash[a]
    end

    def remote_branches
      in_repo do
        `git branch -r`.split("\n").map { |a| a.split(' ')[0] }
      end
    end

    def unmerged_commits(branch, upstream)
      in_repo do
        `git log --pretty=format:"%h#%an#%s" --reverse  --relative-date #{branch}..#{upstream}`.
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

    def flags
      flags = Set.new
      status_lines do |s|
        case s.split[0]
        when 'A'
          flags << :index
        when 'M'
          flags << :dirty
        when '??'
          flags << :untracked
        when '##'
          if /## ([\w,\/]+)\.\.\.([\w,\/]+) \[(\w+) (\d+)\]/ =~ s
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
          if(m = /## ([\w,\/]+)\.\.\.([\w,\/]+) \[(\w+) (\d+)\]/.match(s))
            if m[3] =~ /behind/
              divergence << { :behind => { :branch => m[2], :by => m[4] } }
            else
              divergence << { :ahead => { :branch => m[2], :by => m[4] } }
            end
          end
        end
      end
      divergence
    end

    def dirty?
      [:index, :dirty, :untracked].any? { |f| flags.include?(f) }
    end

  private

    def in_repo
      Dir.chdir(path) { yield }
    end

    def status
      @status ||= in_repo { `git status --short --branch --ignore-submodules`.split("\n") }
    end

    def status_lines
      status.each { |s| yield s }
    end
  end
end
