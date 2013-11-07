require 'set'

module MGit
  class Repository
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def dirty?
      [:index, :dirty, :untracked].any? { |f| flags.include?(f) }
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
          flags << :diverged
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

  private
  
    def status
      @status ||= `git status --short --branch --ignore-submodules`.split("\n") 
    end

    def status_lines
      Dir.chdir(path) do
        status.each do |s|
          yield s
        end
      end
    end
  end
end
