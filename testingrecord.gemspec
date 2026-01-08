# frozen_string_literal: true

require_relative 'lib/testing_record/version'

Gem::Specification.new do |spec|
  spec.name = 'testingrecord'
  spec.version = TestingRecord::VERSION
  spec.authors = ['Luke Hill']
  spec.email = ['lukehill_uk@hotmail.com']

  spec.required_ruby_version = '>= 3.1'

  spec.summary = 'Thread based caching system to store and edit records'
  spec.description = 'Use metaprogrammed cache-models to store data you create on-the-fly. Access and retrieve references to data \
                      created from any place inside your tests.'
  spec.homepage = 'https://github.com/site-prism/testingrecord'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/site-prism/testingrecord/issues',
    'changelog_uri' => 'https://github.com/site-prism/testingrecord/blob/main/CHANGELOG.md',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/site-prism/testingrecord'
  }

  spec.files = Dir.glob('lib/**/*') + %w[LICENSE README.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'automation_helpers', '~> 5.0'
  spec.add_dependency 'logger', '~> 1.7'

  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.82.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.25.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.9.0'
end
