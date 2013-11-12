require 'set'

module MGit
  class Repository
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def current_branch
      in_repo { `git rev-parse --abbrev-ref HEAD`.strip }
    end

    def remote_tracking_branches
      a = in_repo do
        `git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads`.
          split("\n").
          map { |b| b.split(' ') }.
          reject { |b| b.size != 2 }
      end
      
      Hash[a]
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
