node.default['swarm']['swarm_version'] = 'latest'
node.default['swarm']['image']['read_timeout'] = 180

# Specify a host running the discovery service for the Swarm cluster
# If not specified then a search will be run instead
node.default['swarm']['discovery']['host'] = nil
# When a discovery host is not specified the cookbook will attempt to find a discovery
# provider using the specified query
node.default['swarm']['discovery']['query'] = "role:swarm-discovery AND chef_environment:#{node.chef_environment}"
