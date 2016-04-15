default['swarm']['swarm_version'] = 'latest'
default['swarm']['image']['read_timeout'] = 180

# Swarm discovery provider type to use. Valid values are
# token, consul, etcd, zk, file
default['swarm']['discovery']['provider'] = 'token'
# Discovery token to use, only used with provider "token"
default['swarm']['discovery']['token'] = nil
# Path to discovery file. Only used for provider "file"
default['swarm']['discovery']['file_path'] = nil
# Specify a host running the discovery service for the Swarm cluster
# If not specified then a search will be run instead
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['host'] = nil
# When a discovery host is not specified the cookbook will attempt to find a discovery
# provider using the specified query
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['query'] = "role:swarm-discovery AND chef_environment:#{node.chef_environment}"
# Path to append to the end of the key value store URL
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['path'] = nil

default['swarm']['manager']['bind'] = '0.0.0.0'
default['swarm']['manager']['port'] = 3376
default['swarm']['manager']['advertise'] = node['ipaddress']
default['swarm']['manager']['strategy'] = 'spread'
default['swarm']['manager']['replication'] = false
default['swarm']['manager']['replication_ttl'] = '30s'
default['swarm']['manager']['heartbeat'] = nil
default['swarm']['manager']['discovery_options'] = []
default['swarm']['manager']['cluster_driver'] = 'swarm'
# Cluster driver options
default['swarm']['manager']['cluster_options'] = []
# Hook for adding additional arguments to the swarm manage command
# Specified as a Hash of argument names to values
default['swarm']['manager']['additional_options'] = {}
default['swarm']['manager']['restart_policy'] = 'on-failure'
