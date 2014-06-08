module MGit
  class ShowCommand < Command
    def execute(args)
      @commit = args.shift

      case repos.size
      when 0
        perror "Couldn't find commit #{@commit} in any repository."
      when 1
        show_commit(repos.first)
      else
        show_menu
      end
    end

    def arity
      [1, 1]
    end

    def usage
      'show <commit-sha/obj>'
    end

    def description
      'display commit object from any repository'
    end

    register_command :show

    private

    def repos
      @rs || begin
        @rs = []
        Registry.chdir_each do |r|
          @rs << r if commit?
        end
        @rs
      end
    end

    def commit?
      !(System.git("rev-parse --quiet --verify #{@commit}").stdout.empty?)
    end

    def show_commit(repo)
      System.git("show #{@commit}", chdir: repo.path, print_stdout: true)
    end

    def show_menu
      pinfo "Found commit #{@commit} in multiple repositories."
      choose do |menu|
        menu.prompt = 'Which one should be used?'
        repos.each do |r|
          menu.choice(r.name) do
            show_commit(r)
          end
        end
      end
    end
  end
end
