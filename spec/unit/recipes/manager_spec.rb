require 'spec_helper'

describe 'swarm::manager' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm token://fba21ffa43f1e13ef799d293eb74979a'
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
      expect(chef_run).to run_docker_container('swarm-manager').with(
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm etcd://10.2.2.2/swarm'
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
      expect(chef_run).to run_docker_container('swarm-manager').with(
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm file://etc/docker/cluster'
      )
    end
  end
end
