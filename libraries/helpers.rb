module SwarmCookbook
  # Helper methods for Swarm cookbook
  module Helpers
    include Chef::Mixin::ShellOut

    # Build discovery URL using node attributes
    # @return [String]
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

    # Build the full swarm command for launching a manager container
    # @return [String]
    def build_manager_cmd
      cmd = "manage --host #{node['swarm']['manager']['bind']}:#{node['swarm']['manager']['port']}"\
        " --strategy #{node['swarm']['manager']['strategy']} --advertise #{node['swarm']['manager']['advertise']}"\
        " --cluster-driver #{node['swarm']['manager']['cluster_driver']}"

      cmd << " --replication --replication-ttl #{node['swarm']['manager']['replication_ttl']}" if node['swarm']['manager']['replication']
      cmd << " --heartbeat #{node['swarm']['manager']['heartbeat']}" if node['swarm']['manager']['heartbeat']

      add_discovery_options(cmd)
      add_cluster_options(cmd)
      add_additional_options(cmd, node['swarm']['manager']['additional_options'])

      cmd << build_discovery_url
    end

    # Build the full swarm command for launching a worker container
    # @return [String]
    def build_worker_cmd
      cmd = "join --advertise #{node['ipaddress']}:2376"
      cmd << " --heartbeat #{node['swarm']['worker']['heartbeat']}" if node['swarm']['worker']['heartbeat']
      cmd << " --ttl #{node['swarm']['worker']['ttl']}" if node['swarm']['worker']['ttl']

      add_discovery_options(cmd)
      add_additional_options(cmd, node['swarm']['worker']['additional_options'])

      cmd << build_discovery_url
    end

    # Check if a container is running
    # @param [String] container Container name or ID
    # @return [Boolean]
    def container_running?(container)
      cmd = shell_out("docker inspect #{container}")
      result = cmd.stdout
      result =~ /"Status": "blue"/ ? true : false
    end

    private

    def add_additional_options(cmd, options)
      options.each do |k, v|
        cmd << " --#{k} #{v}"
      end
    end

    def add_cluster_options(cmd)
      node['swarm']['manager']['cluster_options'].each do |opt|
        cmd << " --cluster-opt #{opt}"
      end
    end

    def add_discovery_options(cmd)
      node['swarm']['discovery_options'].each do |opt|
        cmd << " --discovery-opt #{opt}"
      end
    end

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
