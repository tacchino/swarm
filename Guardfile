guard 'foodcritic', cli: '-f correctness', cookbook_paths: '.' do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
  watch(%r{templates/.+$})
  watch('metadata.rb')
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/unit/recipes/(.+)_spec\.rb$})
  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/unit/recipes/#{m[1]}_spec.rb" }
  watch(%r{^attributes/(.+)\.rb$})
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
