ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.join(File.dirname(__FILE__), 'mock_app')

require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config', 'environment.rb'))
require 'test_help'

# =============================================================================
# Include the files required to test Engines.

plugin_path = File::dirname(__FILE__) + '/..'
schema_file = plugin_path + "/test/db/schema.rb"
load(schema_file) if File.exist?(schema_file)

# set up the fixtures location to use your engine's fixtures
fixture_path = File.dirname(__FILE__)  + "/fixtures/"
Test::Unit::TestCase.fixture_path = fixture_path
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)
$LOAD_PATH.unshift(File.dirname(__FILE__))
# =============================================================================


