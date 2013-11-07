require 'spec_helper'

describe 'remove command' do
  before do
    @single_repository_state = :managed
  end

  include_context 'single_repository'

  subject(:command) do
    MGit::Command.create('remove')
  end

  context 'with a managed repository' do
    it 'removes the repository from the registry' do
      expect {
        command.execute([@repo_name])
      }.to change { MGit::Registry.all.size }.by(-1)

      expect(MGit::Registry.all).to_not include_repository(@repo_name, @repo_path)
    end
  end
end
