require 'spec_helper'

describe 'swarm::service' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs and runs docker' do
      expect(chef_run).to create_docker_service('default')
      expect(chef_run).to start_docker_service('default')
    end
  end
end
