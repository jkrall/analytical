require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::KissMetrics" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:js_url_key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abc'
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abc'
      a.options.should == {:js_url_key=>'abc', :parent=>@parent}
    end
  end
  describe '#identify' do
    it 'should return a js string' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email=>'test@test.com'}).should == "_kmq.push([\"identify\", \"test@test.com\"]);"
    end
    it 'uses the id parameter when the email parameter is not present' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id').should == "_kmq.push([\"identify\", \"id\"]);"
    end
  end
  describe '#event' do
    it 'should return a js string' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('Big Deal', {:something=>'good'}).should == "_kmq.push([\"record\", \"Big Deal\", #{{:something=>'good'}.to_json}]);"
    end
  end
  describe '#set' do
    it 'should return a js string' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.set({:something=>'good', :b=>2}).should == "_kmq.push([\"set\", #{{:something=>'good', :b=>2}.to_json}]);"
    end
  end
  describe '#alias_identity' do
    it 'should return a js string' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.alias_identity('foo', 'bar').should == "_kmq.push([\"alias\", \"foo\", \"bar\"]);"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::KissMetrics.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should =~ /i\.kissmetrics\.com/
      @api.init_javascript(:body_prepend).should =~ /abcdef/
      @api.init_javascript(:body_append).should == ''
    end
  end
end
