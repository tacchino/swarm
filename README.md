# Swarm Cookbook
Chef cookbook for configuring Docker Swarm nodes.

## Recipes
### default.rb
Pulls the swarm image only. See manager.rb and worker.rb

### manager.rb
Runs a swarm container in "manage" mode

### worker.rb
Runs a swarm container in "join" mode

### service.rb
Uses the Docker cookbook resource to ensure that Docker is installed and running
The recipe uses minimal configuration, it is expected that most cookbook users will set up
Docker directly

#### Attributes
See Docker docs for explanation of Swarm arguments: https://docs.docker.com/swarm/overview/
|Attribute|Default Value|Description|
----------|-------------|------------|
|['swarm']['swarm_version']|'latest'|Version of the Swarm container to use|
|['swarm']['image']['read_timeout']|180|Timeout for image pull| 
|['swarm']['discovery']['provider']|'token'|Swarm discovery provider type to use. Valid values are token, consul, etcd, zk, file|
|['swarm']['discovery']['token']|nil|Discovery token to use, only used with provider "token"|
|['swarm']['discovery']['file_path']|nil|Path to discovery file. Only used for provider "file"| 
|['swarm']['discovery']['host']|nil|Specify a host running the discovery service for the Swarm cluster. If not specified then a search will be run instead. Only used with provider "consul", "etcd" or "zk"| 
|['swarm']['discovery']['query']|"role:swarm-discovery AND chef_environment:#{node.chef_environment}"|When a discovery host is not specified the cookbook will attempt to find a discovery provider using the specified query. Only used with provider "consul", "etcd" or "zk"|
|['swarm']['discovery']['path']|nil|Path to append to the end of the key value store URL. Only used with provider "consul", "etcd" or "zk"|
|['swarm']['restart_policy']|'on-failure'|Swarm container restart policy|
|['swarm']['discovery_options']|[]|Discovery options passed in to the swarm containers|
|['swarm']['manager']['bind']|'0.0.0.0'||
|['swarm']['manager']['port']|3376||
|['swarm']['manager']['advertise']|node['ipaddress']||
|['swarm']['manager']['strategy']|'spread'||
|['swarm']['manager']['replication']|false||
|['swarm']['manager']['replication_ttl']|'30s'||
|['swarm']['manager']['heartbeat']|nil||
|['swarm']['manager']['cluster_driver']|'swarm'||
|['swarm']['manager']['cluster_options']|[]|Cluster driver options| 
|['swarm']['manager']['additional_options']|{}|Hook for adding additional arguments to the swarm manage command. Specified as a Hash of argument names to values|
|['swarm']['worker']['ttl']|nil||
|['swarm']['worker']['heartbeat']|nil||
|['swarm']['worker']['delay']|nil|| 
|['swarm']['worker']['additional_options']|{}|Hook for adding additional arguments to the swarm join command. Specified as a Hash of argument names to values|


## Usage
To create a managing node include swarm::manager in your node's run list
To create a worker node include swarm::worker in your node's run list

Both of the above recipes assume that the Docker engine will be installed and running. 
swarm::service can be included if the engine is not managed through some other cookbook

## License
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
