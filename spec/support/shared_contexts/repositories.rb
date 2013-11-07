shared_context 'unmanaged_repository' do
  before(:each) do
    @repo_name = 'unmanaged'
    @repo_path = File.join(@root, @repo_name)
    FileUtils.mkdir(@repo_path)
    Dir.chdir(@repo_path) { `git init` }
  end
end

shared_context 'managed_repository' do |state|
  state = [] unless state
  state = [state] unless state.is_a?(Array)

  before(:each) do
    @repo_name = 'managed'
    @repo_path = File.join(@root, @repo_name)
    FileUtils.mkdir(@repo_path)
    Dir.chdir(@repo_path) { `git init` }
    MGit::Registry.add(@repo_name, @repo_path)

    if state.include?(:untracked)
      FileUtils.touch(File.join(@repo_path, 'untracked'))
    end

    if state.include?(:dirty)
      Dir.chdir(@repo_path) do
        FileUtils.touch('dirty')
        `git add dirty`
        `git commit -m 'dirty'`
        File.open('dirty', 'w') { |fd| fd.puts 'dirty' }
      end
    end
  end
end
