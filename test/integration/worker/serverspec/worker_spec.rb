require 'spec_helper'

describe 'swarm::worker' do
  it 'runs swarm worker container' do
    expect(docker_container('swarm-worker')).to be_running
  end
end
