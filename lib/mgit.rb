require 'colorize'
require 'highline/import'

require 'mgit/version'
require 'mgit/exceptions'
require 'mgit/registry'
require 'mgit/repository'

require 'mgit/cli'
require 'mgit/command'
Dir["#{File.expand_path('../mgit/commands', __FILE__)}/*.rb"].each { |file| require file }

module MGit
end
