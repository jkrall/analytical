$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_support'
require 'spec'
require 'spec/autorun'

require 'analytical'
require 'analytical/api'
require 'analytical/base'
require 'analytical/console'
require 'analytical/google'
require 'analytical/clicky'


Spec::Runner.configure do |config|

end

module Rails
end