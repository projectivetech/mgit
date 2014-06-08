module MGit
  module Registry
    extend Enumerable

    def self.all
      load.map { |name, path| Repository.new(name, path) }.sort_by(&:path)
    end

    def self.available
      all.select(&:available?)
    end

    def self.each(&block)
      available.each(&block)
    end

    def self.chdir_each
      available.select(&:available?).each do |repo|
        Dir.chdir(repo.path) do
          yield repo
        end
      end
    end

    def self.find(&block)
      all.find(&block)
    end

    def self.add(name, path)
      repos = load
      repos[name] = path
      save! repos
    end

    def self.remove(name)
      repos = load
      repos.delete name
      save! repos
    end

    def self.clean
      save!({})
    end

    private

    def self.load
      AppData.load(:repositories)
    end

    def self.save!(repos)
      AppData.save!(:repositories, repos)
    end
  end
end
