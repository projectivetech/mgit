require 'fileutils'
require 'yaml'

module MGit
  module AppData
    ####################
    # Module interface #
    ####################

    def self.update
      if AppDataVersion.active
        AppDataVersion.updates.each { |u| u.migrate! }
      else
        AppDataVersion.latest.setup!
      end
    end

    def self.load(key, default = {})
      AppDataVersion.latest.load(key, default)
    end

    def self.save!(key, value)
      AppDataVersion.latest.save!(key, value)
    end

    #########################################
    # Base class for data storage versions. #
    #########################################

    class AppDataVersion
      def self.inherited(version)
        @versions ||= []
        @versions << version.new
        super
      end

      def self.sorted
        @versions.sort_by { |v| v.version }
      end

      def self.updates
        sorted.drop_while { |v| !v.active? }.drop(1)
      end

      def self.active
        sorted.find { |v| v.active? }
      end

      def self.latest
        sorted.last
      end

      include Comparable

      def <=>(other)
        version <=> other.version
      end

      [:version, :active?, :load, :save!, :migrate!].each do |meth|
        define_method(meth) do
          fail ImplementationError, "AppDataVersion #{self.class.name} doesn't implement the #{meth} method."
        end
      end
    end

    #######################################################################
    # Original version, plain YAML file containing the repositories hash. #
    #######################################################################

    class LegacyAppData < AppDataVersion
      def version
        0
      end

      def active?
        File.file?(repofile)
      end

      def setup!
        FileUtils.touch(repofile)
      end

      def load(key, default)
        fail ImplementationError, "LegacyAppData::load called with unknown key #{key}." if key != :repositories
        repos = YAML.load_file(repofile)
        repos ? repos : default
      end

      def save!(key, value)
        fail ImplementationError, "LegacyAppData::save! called with unknown key #{key}." if key != :repositories
        File.open(repofile, 'w') { |fd| fd.write value.to_yaml }
      end

      private

      def repofile
        XDG['CONFIG_HOME'].to_path.join('mgit.yml')
      end
    end

    class AppDataVersion1 < AppDataVersion
      def version
        1
      end

      def active?
        File.directory?(config_dir) && (load(:version, nil) == '1')
      end

      def migrate!
        setup!

        old_repofile = LegacyAppData.new.send(:repofile)
        FileUtils.mv(old_repofile, repo_file) if File.file?(old_repofile)
      end

      def setup!
        FileUtils.mkdir_p(config_dir)
        File.open(config_file, 'w') { |fd| fd.write({ version: '1' }.to_yaml) }
        FileUtils.touch(repo_file)
      end

      def load(key, default)
        case key
        when :repositories
          repos = YAML.load_file(repo_file)
          repos ? repos : default
        when :version, *Configuration::KEYS.keys
          config = YAML.load_file(config_file)
          (config && config.key?(key)) ? config[key] : default
        else
          fail ImplementationError, "AppDataVersion1::load called with unknown key #{key}."
        end
      end

      def save!(key, value)
        case key
        when :repositories
          File.open(repo_file, 'w') { |fd| fd.write value.to_yaml }
        when *Configuration::KEYS.keys
          config = YAML.load_file(config_file)
          config[key] = value
          File.open(config_file, 'w') { |fd| fd.write config.to_yaml }
        else
          fail ImplementationError, "AppDataVersion1::save! called with unknown key #{key}."
        end
      end

      private

      def config_dir
        XDG['CONFIG_HOME'].to_path.join('mgit')
      end

      def repo_file
        File.join(config_dir, 'repositories.yml')
      end

      def config_file
        File.join(config_dir, 'config.yml')
      end
    end
  end
end
