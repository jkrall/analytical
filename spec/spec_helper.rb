require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

#require "rails/application"
#require File.expand_path("../../config/environment", __FILE__)

require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require 'action_view'
require 'active_model'
require 'action_controller'
require 'rails'
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.before do
    Rails.stub(:root).and_return(Pathname.new(__FILE__).dirname)
  end
end

require 'analytical'

