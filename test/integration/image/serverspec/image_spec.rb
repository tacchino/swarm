require 'spec_helper'

describe 'swarm::default' do
  it 'pulls the swarm image' do
    expect(docker_image('swarm:latest')).to exist
  end
end
