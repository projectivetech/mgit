module MGit
  module Configuration
    KEYS = {
      :threads => {
        :default => true,
        :description => 'set to true if you want the fetch command to be threaded'
      },

      :plugindir => {
        :default => File.join(AppData::AppDataVersion.latest.send(:config_dir), 'plugins'),
        :description => 'directory from where plugin commands are loaded'
      }
    }

    class << self
      KEYS.each do |k, v|
        define_method(k.to_s) do
          AppData.load(k, v[:default])
        end

        define_method("#{k.to_s}=") do |value|
          AppData.save!(k, value)
        end

        private "#{k.to_s}="
      end
    end

    def self.set(key, value)
      case key
      when 'threads'
        unless ['true', 'false', 'on', 'off'].include?(value)
          raise ConfigurationError.new("Illegal value for key threads.")
        end

        if ['true', 'on'].include?(value)
          self.threads = true
        else
          self.threads = false
        end
      else
        raise ConfigurationError.new("Unknown key: #{key}.")
      end
    end
  end
end
