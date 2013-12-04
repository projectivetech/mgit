require 'yaml'

module MGit
  module Registry
    def self.all
      self.load.map { |name, path| Repository.new(name, path) }.sort_by(&:path)
    end

    def self.each(&block)
      self.all.each(&block)
    end

    def self.chdir_each
      self.all.each do |repo|
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

    def self.repofile
      XDG['CONFIG_HOME'].to_path.join('mgit.yml')
    end

    def self.load
      File.exists?(self.repofile) ? YAML.load_file(self.repofile) : {}
    end

    def self.save!(repos)
      File.open(self.repofile, 'w') { |fd| fd.write repos.to_yaml }
    end
  end
end
