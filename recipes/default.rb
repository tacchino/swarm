#
# Cookbook Name:: swarm
# Recipe:: default
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

docker_image 'swarm' do
  tag node['swarm']['swarm_version']
  read_timeout node['swarm']['image']['read_timeout']
  action :pull_if_missing
end