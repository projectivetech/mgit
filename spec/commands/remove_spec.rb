require 'spec_helper'

describe 'remove command' do
  subject(:command) do
    MGit::Command.create('remove')
  end

  context 'with a managed repository' do
    include_context 'silence'
    include_context 'managed_repository'

    context 'given the name of the repository' do
      it 'removes the repository from the registry' do
        expect do
          command.execute([@repo_name])
        end.to change { MGit::Registry.all.size }.by(-1)

        expect(MGit::Registry.all).to_not include_repository(@repo_name, @repo_path)
      end
    end

    context 'given the path of the repository' do
      it 'removes the repository from the registry' do
        expect do
          command.execute([@repo_path])
        end.to change { MGit::Registry.all.size }.by(-1)

        expect(MGit::Registry.all).to_not include_repository(@repo_name, @repo_path)
      end
    end
  end

  context 'with an unmanaged repository' do
    include_context 'unmanaged_repository'

    it 'raises an error' do
      expect do
        command.execute([@repo_path])
      end.to raise_error(MGit::CommandUsageError)
    end
  end

  context 'given an unknown name' do
    it 'raises an error' do
      expect do
        command.execute(['unknown'])
      end.to raise_error(MGit::CommandUsageError)
    end
  end
end
