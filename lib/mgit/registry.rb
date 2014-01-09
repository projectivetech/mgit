module MGit
  module Registry
    def self.all
      self.load.map { |name, path| Repository.new(name, path) }.sort_by(&:path)
    end

    def self.available
      self.all.select(&:available?)
    end

    def self.each(&block)
      self.available.each(&block)
    end

    def self.chdir_each
      self.available.select(&:available?).each do |repo|
        Dir.chdir(repo.path) do
          yield repo
        end
      end
    end

    def self.find(&block)
      self.all.find(&block)
    end

    def self.add(name, path)
      repos = self.load
      repos[name] = path
      self.save! repos
    end

    def self.remove(name)
      repos = self.load
      repos.delete name
      self.save! repos
    end

    def self.clean
      self.save!({})
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
