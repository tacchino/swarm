#
# Cookbook Name:: swarm
# Spec:: default
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

require 'spec_helper'

describe 'swarm::default' do
  before do
    stub_search(:node, 'role:swarm-discovery AND chef_environment:_default').and_return([{ipaddress: '10.1.1.1'}])
  end

  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'pulls the swarm image' do
      expect(chef_run).to pull_if_missing_docker_image('swarm').with(
        tag: 'latest',
        read_timeout: 180
      )
    end
  end

  context 'When image attributes are specified' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.set['swarm']['swarm_version'] = '1.0.1'
        node.set['swarm']['image']['read_timeout'] = 60
      end
      runner.converge(described_recipe)
    end

    it 'pulls the swarm image' do
      expect(chef_run).to pull_if_missing_docker_image('swarm').with(
        tag: '1.0.1',
        read_timeout: 60
      )
    end
  end
end
