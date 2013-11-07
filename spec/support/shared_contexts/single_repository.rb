shared_context 'single_repository' do
  before(:each) do
    @single_repository_state ||= :initialized

    @repo_name = 'repo'
    @repo_path = File.join(@root, @repo_name)

    FileUtils.mkdir(@repo_path)
    next if @single_repository_state == :created

    Dir.chdir(@repo_path) { `git init` }
    next if @single_repository_state == :initialized

    MGit::Command.create('add').execute([@repo_path, @repo_name])
    next if @single_repository_state == :managed
  end
end
