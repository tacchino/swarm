#
# Cookbook Name:: swarm
# Recipe:: worker
#
# Copyright 2016 Brent Walker
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
::Chef::Recipe.send(:include, SwarmCookbook::Helpers)

include_recipe 'swarm::default'

cmd = build_worker_cmd

docker_container 'swarm-worker' do
  repo 'swarm'
  tag node['swarm']['swarm_version']
  command cmd
  restart_policy node['swarm']['restart_policy']
  action :run
end
