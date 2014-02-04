require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::GoogleUniveresal" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe "on initialize" do
    it "should set the command_location" do
      a = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :head_append
    end
    it 'should set the options' do
      a = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end
  end
  describe '#event' do
    it 'should return the event javascript' do
      @api = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename').should ==  "ga('send', 'event', 'Event', 'pagename' );"
    end
    it 'should include data value' do
      @api = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:value=>555, :more=>'info'}).should ==  "ga('send', 'event', 'Event', 'pagename' , 555);"
    end
    it 'should not include data if there is no value' do
      @api = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:more=>'info'}).should ==  "ga('send', 'event', 'Event', 'pagename' );"
    end
    it 'should not include data if it is not a hash' do
      @api = Analytical::Modules::GoogleUniversal.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', 555).should ==  "ga('send', 'event', 'Event', 'pagename' , 555);"
    end
  end
end