require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Analytical::Modules::SegmentIo do
  before(:each) do
    @parent = mock('api', :options=>{:segment_io=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = described_class.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should eq :head_prepend
    end
    it 'should set the options' do
      a = described_class.new :parent=>@parent, :key=>'abc'
      a.options.should eq({:key=>'abc', :parent=>@parent})
    end
  end
  describe '#track' do
    it 'should return the pageview javascript' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.track.should eq "window.analytics.pageview();"
      @api.track('pagename', {:some=>'data'}).should eq  "window.analytics.pageview(\"pagename\");"
    end
  end
  describe '#event' do
    it 'should return the track javascript' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename').should eq "window.analytics.track(\"pagename\", {});"
    end

    it 'should include data value' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:value=>555, :more=>'info'}).should eq "window.analytics.track(\"pagename\", {\"value\":555,\"more\":\"info\"});"
    end
    it 'should not include data if there is no value' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:more=>'info'}).should eq  "window.analytics.track(\"pagename\", {\"more\":\"info\"});"
    end
    it 'should not include data if it is not a hash' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', 555).should eq  "window.analytics.track(\"pagename\", 555);"
    end
  end
  describe '#identify' do
    it 'should return the identify javascript' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com'}).should == "window.analytics.identify(\"id\", {\"email\":\"test@test.com\"});"
    end
  end

  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = described_class.new :parent=>@parent, :key=>'abcdef'
      @api.init_javascript(:head_append).should eq ''
      @api.init_javascript(:head_prepend).should =~ /window.analytics=/
      @api.init_javascript(:head_prepend).should =~ /abcdef/
      @api.init_javascript(:head_prepend).should =~ /analytics.js\/v1/
      @api.init_javascript(:body_prepend).should eq ''
      @api.init_javascript(:body_append).should eq ''
    end
  end
end
