require 'rspec'
require 'fileutils'
require 'mgit'

# Require support files
Dir["#{File.absolute_path(File.dirname(__FILE__))}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    # Create test data directory.
    @root = File.expand_path('../root', __FILE__)
    FileUtils.mkdir(@root)

    # Stub the configuration file.
    @repofile = File.expand_path('../root/mgit.yml', __FILE__)
    MGit::Registry.stub(:repofile).and_return(@repofile)

    # Silence output.
    @original_stderr = $stderr
    @original_stdout = $stdout
    $stdout = File.new(File.join(@root, 'stdout.log'), 'w')
    $stderr = File.new(File.join(@root, 'stderr.log'), 'w')
  end

  config.after(:each) do
    # Clean up test data.
    FileUtils.rm_r(@root)

    # Re-enable output.
    $stderr = @original_stderr
    $stdout = @original_stdout
  end
end
