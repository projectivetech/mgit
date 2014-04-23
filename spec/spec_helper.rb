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

    # Stub the XDG home.
    class << @root; def to_path; Pathname.new(self); end; end
    XDG.stub(:[]).and_return(@root)

    MGit.init
  end

  config.after(:each) do
    # Clean up test data.
    FileUtils.rm_rf(@root)
  end
end
