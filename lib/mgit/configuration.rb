module MGit
  module Configuration
    extend Enumerable

    KEYS = {
      threads: {
        default: true,
        description: 'set to true if you want the fetch command to be threaded'
      },

      plugindir: {
        default: File.join(AppData::AppDataVersion.latest.send(:config_dir), 'plugins'),
        description: 'directory from where plugin commands are loaded'
      },

      colors: {
        default: true,
        description: 'set to false to disable all colored output'
      }
    }

    class << self
      KEYS.each do |k, v|
        define_method(k.to_s) do
          AppData.load(k, v[:default])
        end

        define_method("#{k}=") do |value|
          AppData.save!(k, value)
        end

        private "#{k}="
      end
    end

    def self.set(key, value)
      case key
      when 'threads', 'colors'
        set_boolean(key, value)
      when 'plugindir'
        unless File.directory?(value)
          fail ConfigurationError, 'Illegal value for key plugindir. Has to be a directory.'
        end
        self.plugindir = File.expand_path(value)
      else
        fail ConfigurationError, "Unknown key: #{key}."
      end
    end

    def self.each
      KEYS.each do |key|
        yield [key.first.to_s, send(key.first).to_s]
      end
    end

    def self.method_missing(meth, *)
      fail ConfigurationError, "Unknown key: #{meth}"
    end

    private

    def self.set_boolean(key, value)
      unless %w( true, false, on, off ).include?(value)
        fail ConfigurationError, "Illegal value for key #{key}."
      end

      if %w( true, on ).include?(value)
        send("#{key}=", true)
      else
        send("#{key}=", false)
      end
    end
  end
end
