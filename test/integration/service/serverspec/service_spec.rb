require 'spec_helper'

describe 'swarm::service' do
  it 'installs and runs docker' do
    expect(service('docker')).to be_running
    expect(service('docker')).to be_enabled
  end

  it 'binds to 2376' do
    expect(port(2376)).to be_listening
  end
end
