class PageController < ApplicationController
  def index
  end

  def test_a
  end

  def test_b
    analytical.clicky.track('track link in A')
    analytical.track 'track in controller'
  end

  def test_c
    analytical.track 'track in controller that redirects'
    redirect_to root_path
  end

end
