require 'yaml'

module MGit
  module Repository
    def self.all
      File.exists?(self.repofile) ? YAML.load_file(self.repofile) : {}
    end

    def self.each(&block)
      self.all.each(&block)
    end

    def self.add(name, path)
      repos = self.all
      repos[name] = path
      File.open(self.repofile, 'w') { |fd| fd.write repos.to_yaml }
    end

  private

    def self.repofile
      File.join(Dir.home, '.config/mgit.yml')
    end
  end
end
