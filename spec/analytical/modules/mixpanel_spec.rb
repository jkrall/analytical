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
      @api.identify('id', {:email=>'test@test.com'}).should == "mpmetrics.identify('id');"
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data'}).should == "mpmetrics.track('pagename', {\"some\":\"data\"}, function(){});"
    end
    it 'should return the tracking javascript with a callback' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data', :callback=>'fubar'}).should == "mpmetrics.track('pagename', {\"some\":\"data\"}, fubar);"
    end
  end
  describe '#event' do
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('My Funnel', {:step=>5, :goal=>'thegoal'}).should == "mpmetrics.track_funnel('My Funnel', '5', 'thegoal', {}, function(){});"
    end
    describe 'without the proper data' do
      it 'should return an error string with blank funnel' do
        @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
        @api.event('', {:step=>5, :goal=>'thegoal'}).should =~ /Funnel is not set/
      end
      it 'should return an error string with blank step' do
        @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
        @api.event('My Funnel', {:goal=>'thegoal'}).should =~ /Step is not set/
      end
      it 'should return an error string with step < 0' do
        @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
        @api.event('My Funnel', {:step=>-1, :goal=>'thegoal'}).should =~ /Step is not set/
      end
      it 'should return an error string with blank goal' do
        @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
        @api.event('My Funnel', {:step=>5}).should =~ /Goal is not set/
      end
    end
    it 'should return a js string' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('My Funnel', {:step=>5, :goal=>'thegoal', :callback=>'thecallback', :other=>'data'}).should == "mpmetrics.track_funnel('My Funnel', '5', 'thegoal', {\"other\":\"data\"}, thecallback);"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Mixpanel.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ /api\.mixpanel\.com\/site_media\/js\/api\/mixpanel\.js/
      @api.init_javascript(:body_append).should =~ /new MixpanelLib\('.*'\)/
    end
  end
end
