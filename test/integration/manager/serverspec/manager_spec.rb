require 'spec_helper'

describe 'swarm::manager' do
  it 'runs swarm manager container' do
    expect(docker_container('swarm-manager')).to be_running
  end
end
