class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  analytical :modules=>[:console, :google, :clicky], :disable_if=>lambda{false}, :use_session_store=>true
end
