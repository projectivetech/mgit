require 'spec_helper'

describe 'status command' do
  include_context 'silence'
  include_context 'managed_repository', :history

  subject(:command) do
    MGit::Command.create('head')
  end

  it 'reports the current branch' do
    puts MGit::Registry.all.inspect
    command.execute([])
    expect(@stdout.string).to match(/master/)
  end

  it 'reports the current HEAD commit' do
    command.execute([])
    Dir.chdir(@repo_path) do
      puts $stdout.inspect
      commit = `git rev-parse --verify --short HEAD`.strip
      expect(@stdout.string).to include(commit)
    end
  end
end
