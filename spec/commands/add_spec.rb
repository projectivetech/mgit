require 'spec_helper'

describe 'add command' do
  include_context 'single_repository'

  subject(:command) do
    MGit::Command.create('add')
  end

  context 'with an unmanaged repository' do
    it 'adds the repository to the registry' do
      expect {
        command.execute([@repo_path, @repo_name])
      }.to change { MGit::Registry.all.size }.by(1)

      expect(MGit::Registry.all).to include_repository(@repo_name, @repo_path)
    end
  end

  context 'with a managed repository' do
    before(:each) do
      command.execute([@repo_path, @repo_name])
    end

    it 'does not add the repository twice' do
      expect {
        command.execute([@repo_path, @repo_name])
      }.to_not change { MGit::Registry.all.size }
    end

    it 'does not raise an error' do
      expect { 
        command.execute([@repo_path, @repo_name])
      }.to_not raise_error
    end
  end
end
