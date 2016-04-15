require 'spec_helper'

describe 'swarm::worker' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm worker container' do
      expect(chef_run).to run_docker_container('swarm-worker').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'join --advertise 10.1.1.1:2376 token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end

  context 'When using a KV discovery' do
    before do
      stub_search("node", "role:swarm-discovery AND chef_environment:_default").and_return([{ipaddress: '10.2.2.2'}])
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['provider'] = 'etcd'
        node.set['swarm']['discovery']['path'] = 'swarm'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-worker').with(
        command: 'join --advertise 10.1.1.1:2376 etcd://10.2.2.2/swarm'
      )
    end
  end

  context 'When using file discovery' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['provider'] = 'file'
        node.set['swarm']['discovery']['file_path'] = 'etc/docker/cluster'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-worker').with(
        command: 'join --advertise 10.1.1.1:2376 file://etc/docker/cluster'
      )
    end
  end
end