require 'spec_helper'

describe 'status command' do
  include_context 'silence'

  subject(:command) do
    MGit::Command.create('status')
  end

  context 'with a clean repository' do
    include_context 'managed_repository'
    
    it 'reports clean' do
      command.execute([])
      expect(@stdout.string).to match(/Clean/)
    end
  end

  context 'with an untracked file' do
    include_context 'managed_repository', :untracked

    it 'reports untracked' do
      command.execute([])
      expect(@stdout.string).to match(/Untracked/)
    end
  end

  context 'with a dirty file' do
    include_context 'managed_repository', :dirty

    it 'reports dirty' do
      command.execute([])
      expect(@stdout.string).to match(/Dirty/)
    end
  end

  context 'in detached HEAD state' do
    include_context 'managed_repository', :detached

    it 'reports detached' do
      command.execute([])
      expect(@stdout.string).to match(/Detached/)
    end
  end

  context 'with an indexed file' do
    include_context 'managed_repository', :index

    it 'reports index' do
      command.execute([])
      expect(@stdout.string).to match(/Index/)
    end
  end
end
