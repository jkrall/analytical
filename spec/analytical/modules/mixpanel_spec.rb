require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Mixpanel" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:js_url_key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abc'
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abc'
      a.options.should == {:js_url_key=>'abc', :parent=>@parent}
    end
  end
  describe '#identify' do
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com'}).should == "mixpanel.identify('id');"
    end
    it 'should return a js string with name if included' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com', :name => "user_name"}).should == "mixpanel.identify('id'); mixpanel.name_tag('user_name');"
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data'}).should == "mixpanel.track(\"pagename\", {\"some\":\"data\"}, function(){});"
    end
    it 'should return the tracking javascript with a callback' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data', :callback=>'fubar'}).should == "mixpanel.track(\"pagename\", {\"some\":\"data\"}, fubar);"
    end
  end
  describe '#event' do
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('An event happened', { :item => 43 }).should == "mixpanel.track(\"An event happened\", {\"item\":43});"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ %r(cdn\.mxpnl\.com\/libs/mixpanel-2\.1\.min\.js)
      @api.init_javascript(:body_append).should =~ %r(mixpanel\.init\("abcdef"\))
      @api.init_javascript(:body_append).should =~ %r(<script type="text\/javascript">)
    end
  end
end
