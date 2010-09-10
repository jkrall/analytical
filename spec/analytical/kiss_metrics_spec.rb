require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::KissMetrics::Api" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:js_url_key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abc'
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abc'
      a.options.should == {:js_url_key=>'abc', :parent=>@parent}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.track('pagename', {:some=>'data'}).should == ''
    end
  end
  describe '#identify' do
    it 'should return a js string' do
      @api = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com'}).should == "_kmq.push([\"identify\", \"test@test.com\"]);"
    end
  end
  describe '#event' do
    it 'should return a js string' do
      @api = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('Big Deal', {:something=>'good'}).should == "_kmq.push([\"record\", \"Big Deal\", #{{:something=>'good'}.to_json}]);"
    end
  end
  describe '#set' do
    it 'should return a js string' do
      @api = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.set({:something=>'good', :b=>2}).should == "_kmq.push([\"set\", #{{:something=>'good', :b=>2}.to_json}]);"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::KissMetrics::Api.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should =~ /i\.kissmetrics\.com/
      @api.init_javascript(:body_prepend).should =~ /abcdef/      
      @api.init_javascript(:body_append).should == ''
    end
  end
end
