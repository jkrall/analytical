require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::BotDetector" do
  class DummyForBotDetector
    include Analytical::BotDetector
  end
  before(:each) do
    @d = DummyForBotDetector.new
  end
  
  describe 'with nil user_agent' do
    it 'should return false' do
      @d.analytical_is_robot?(nil).should be_false
    end
  end

  describe 'with empty user_agent' do
    it 'should return false' do
      @d.analytical_is_robot?('').should be_false
    end
  end
  
  describe 'with whitelist user_agent' do
    it 'should return false' do
      @d.analytical_is_robot?('whitelist', ['whitelist']).should be_false
    end
  end

  describe 'with whitelist user_agent' do
    it 'should return true' do
      @d.analytical_is_robot?('whitelist').should be_true
    end
  end
end
