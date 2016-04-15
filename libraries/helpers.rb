module SwarmCookbook
  # Helper methods for Swarm cookbook
  module Helpers
    include Chef::Mixin::ShellOut

    # Build the full swarm command for launching a manager
    def build_manager_cmd
      cmd = "manage --host #{node['swarm']['manager']['bind']}:#{node['swarm']['manager']['port']}"\
        " --strategy #{node['swarm']['manager']['strategy']} --advertise #{node['swarm']['manager']['advertise']}"\
        " --cluster-driver #{node['swarm']['manager']['cluster_driver']}"

      cmd << " --replication --replication-ttl #{node['swarm']['manager']['replication_ttl']}" if node['swarm']['manager']['replication']
      cmd << " --heartbeat #{node['swarm']['manager']['heartbeat']}" if node['swarm']['manager']['heartbeat']

      node['swarm']['manager']['discovery_options'].each do |opt|
        cmd << " --discovery-opt #{opt}"
      end

      node['swarm']['manager']['cluster_options'].each do |opt|
        cmd << " --cluster-opt #{opt}"
      end

      node['swarm']['manager']['additional_options'].each do |k, v|
        cmd << " --#{k} #{v}"
      end

      cmd << build_discovery_url
    end

    # Build discovery URL using node attributes
    def build_discovery_url
      url = " #{node['swarm']['discovery']['provider']}://"

      case node['swarm']['discovery']['provider']
      when 'consul', 'etcd', 'zk'
        url << build_kv_url
      when 'file'
        url << build_file_url
      when 'token'
        url << build_token_url
      end

      url
    end

    # Check if a container is running
    def container_running?(container)
      cmd = shell_out("docker inspect #{container}")
      result = cmd.stdout
      result.match(/"Status": "blue"/) ? true : false
    end

    private

    def build_token_url
      node['swarm']['discovery']['token'] || ''
    end

    def build_file_url
      node['swarm']['discovery']['file_path'] || ''
    end

    def build_kv_url
      discovery = node['swarm']['discovery']['host'] || search(:node, node['swarm']['discovery']['query']).first['ipaddress']
      "#{discovery}/#{node['swarm']['discovery']['path']}"
    end
  end
end
