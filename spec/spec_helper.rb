require 'rspec'
require 'fileutils'
require 'mgit'
require 'stringio'

# Require support files
Dir["#{File.absolute_path(File.dirname(__FILE__))}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    @root = File.expand_path('../root', __FILE__)
    @repofile = File.expand_path('../root/mgit.yml', __FILE__)

    # Create test data directory.
    FileUtils.mkdir(@root)

    # Stub the configuration file.
    MGit::Registry.stub(:repofile).and_return(@repofile)
  end

  config.after(:each) do
    # Clean up test data.
    FileUtils.rm_r(@root)
  end
end
