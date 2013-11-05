require 'yaml'

module MGit
  module Registry
    def self.all
      File.exists?(self.repofile) ? YAML.load_file(self.repofile) : {}
    end

    def self.each(&block)
      self.all.each(&block)
    end

    def self.chdir_each
      self.all.each do |name, path|
        Dir.chdir(path) do
          yield name, path
        end
      end
    end

    def self.find(&block)
      self.all.find(&block)
    end

    def self.add(name, path)
      repos = self.all
      repos[name] = path
      self.save! repos
    end

    def self.remove(name)
      repos = self.all
      repos.delete name
      self.save! repos
    end

  private

    def self.repofile
      File.join(Dir.home, '.config/mgit.yml')
    end

    def self.save!(repos)
      File.open(self.repofile, 'w') { |fd| fd.write repos.to_yaml }
    end
  end
end
