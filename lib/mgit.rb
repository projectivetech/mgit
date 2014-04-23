require 'colorize'
require 'highline/import'
require 'xdg'

require 'mgit/version'
require 'mgit/appdata'
require 'mgit/configuration'
require 'mgit/exceptions'
require 'mgit/output'
require 'mgit/registry'
require 'mgit/repository'
require 'mgit/system'

require 'mgit/cli'
require 'mgit/command'

module MGit
  def self.init
    # Initialize AppData and migrate if necessary.
    AppData.update

    # Initialize Commands.
    MGit::Command.load_commands
  end
end
