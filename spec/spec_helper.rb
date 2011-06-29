$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require 'action_view'

require 'analytical'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end

module Rails
  def self.root
    File.dirname(__FILE__)
  end
end
