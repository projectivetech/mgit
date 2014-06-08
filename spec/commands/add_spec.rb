require 'spec_helper'

describe 'add command' do
  subject(:command) do
    MGit::Command.create('add')
  end

  context 'with an unmanaged repository' do
    include_context 'unmanaged_repository'

    it 'adds the repository to the registry' do
      expect do
        command.execute([@repo_path, @repo_name])
      end.to change { MGit::Registry.all.size }.by(1)

      expect(MGit::Registry.all).to include_repository(@repo_name, @repo_path)
    end
  end

  context 'with a managed repository' do
    include_context 'managed_repository'

    it 'does not add the repository twice' do
      expect do
        command.execute([@repo_path, @repo_name])
      end.to_not change { MGit::Registry.all.size }
    end

    it 'does not raise an error' do
      expect do
        command.execute([@repo_path, @repo_name])
      end.to_not raise_error
    end
  end
end
