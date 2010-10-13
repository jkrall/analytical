$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require 'action_view'
require 'spec'
require 'spec/autorun'

require 'analytical'

Spec::Runner.configure do |config|
end

module Rails
  def self.root
    File.dirname(__FILE__)
  end
end
