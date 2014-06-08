shared_context 'silence' do
  before(:each) do
    # Silence output.
    @original_stderr = $stderr
    @original_stdout = $stdout
    @stdout = StringIO.new
    @stderr = StringIO.new
    $stdout = @stdout
    $stderr = @stderr
  end

  after(:each) do
    # Re-enable output.
    $stderr = @original_stderr
    $stdout = @original_stdout
  end
end
