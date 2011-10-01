class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  analytical :modules=>[:console, :google, :clicky], :disable_if=>lambda{|controller| false}, :use_session_store=>true
end
