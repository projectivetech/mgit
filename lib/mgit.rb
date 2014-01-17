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

require 'mgit/cli'
require 'mgit/command'
Dir["#{File.expand_path('../mgit/commands', __FILE__)}/*.rb"].each { |file| require file }

module MGit
end
