module MGit
  class RemoveAllCommand < Command
    def execute(_)
      Registry.clean if agree('This will delete all repositories from mgit. Are you sure?'.red)
    end

    def arity
      [0, 0]
    end

    def usage
      'removeall'
    end

    def description
      'removes all repositories from mgit (resets mgit\'s store)'
    end

    register_command :removeall
    register_alias :remove_all
  end
end
