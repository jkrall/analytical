class PageController < ApplicationController
  def index
  end

  def test_a
  end

  def test_b
    analytical.track 'track in controller'
  end
end
