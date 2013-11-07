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

  raise 'detached + dirty' if state.include?(:detached) && state.include?(:dirty)
  raise 'detached + index' if state.include?(:detached) && state.include?(:index)

  before(:each) do
    @repo_name = 'managed'
    @repo_path = File.join(@root, @repo_name)
    FileUtils.mkdir(@repo_path)
    Dir.chdir(@repo_path) { `git init` }
    MGit::Registry.add(@repo_name, @repo_path)

    if state.include?(:untracked)
      FileUtils.touch(File.join(@repo_path, 'untracked'))
    end

    if state.include?(:detached)
      Dir.chdir(@repo_path) do
        FileUtils.touch('commit1')
        `git add commit1`
        `git commit -m 'commit1'`
        FileUtils.touch('commit2')
        `git add commit2`
        `git commit -m 'commit2'`
        `git checkout HEAD^ 2>&1 &>/dev/null` # TODO: Why isn't this silenced by the shared context?
      end
    end

    if state.include?(:dirty)
      Dir.chdir(@repo_path) do
        FileUtils.touch('dirty')
        `git add dirty`
        `git commit -m 'dirty'`
        File.open('dirty', 'w') { |fd| fd.puts 'dirty' }
      end
    end

    if state.include?(:index)
      Dir.chdir(@repo_path) do
        FileUtils.touch('index')
        `git add index`
      end
    end
  end
end
