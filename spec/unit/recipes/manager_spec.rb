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

  context 'When specifying replication' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'

        node.set['swarm']['manager']['replication'] = true
        node.set['swarm']['manager']['replication_ttl'] = '60s'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm --replication --replication-ttl 60s token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end

  context 'When specifying heartbeat' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'

        node.set['swarm']['manager']['heartbeat'] = '20s'
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm --heartbeat 20s token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end

  context 'When specifying discovery options' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'

        node.set['swarm']['discovery_options'] = ['option1', 'option2']
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm --discovery-opt option1 --discovery-opt option2 token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end

  context 'When specifying cluster options' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'

        node.set['swarm']['manager']['cluster_options'] = ['option1', 'option2']
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm --cluster-opt option1 --cluster-opt option2 token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end

  context 'When specifying additional options' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['ipaddress'] = '10.1.1.1'
        node.set['swarm']['discovery']['token'] = 'fba21ffa43f1e13ef799d293eb74979a'

        node.set['swarm']['manager']['additional_options'] = {
          tlsverify: nil,
          tlscacert: '/etc/docker/tls/ca.pem',
          tlscert: '/etc/docker/tls/cert.pem',
          tlskey: '/etc/docker/tls/key.pem'
        }
      end

      runner.converge(described_recipe)
    end

    it 'runs the swarm manager container' do
      expect(chef_run).to run_docker_container('swarm-manager').with(
        tag: 'latest',
        restart_policy: 'on-failure',
        command: 'manage --host 0.0.0.0:3376 --strategy spread --advertise 10.1.1.1 --cluster-driver swarm --tlsverify  --tlscacert /etc/docker/tls/ca.pem --tlscert /etc/docker/tls/cert.pem --tlskey /etc/docker/tls/key.pem token://fba21ffa43f1e13ef799d293eb74979a'
      )
    end
  end
end
