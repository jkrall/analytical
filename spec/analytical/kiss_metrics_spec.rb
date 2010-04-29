require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::KissMetrics::Api" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::KissMetrics::Api.new @parent, {:key=>'abc'}
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::KissMetrics::Api.new @parent, {:key=>'abc'}
      a.options.should == {:key=>'abc'}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::KissMetrics::Api.new @parent, {:key=>'abcdef'}
      @api.track('pagename', {:some=>'data'}).should == ''
    end
  end
  describe '#identify' do
    it 'should return an empty string' do
      @api = Analytical::KissMetrics::Api.new @parent, {:key=>'abcdef'}
      @api.identify('id', {:email=>'test@test.com'}).should == "_kmq.push([\"identify\", \"test@test.com\"]);"
    end
  end
  describe '#event' do
    it 'should return an empty string' do
      @api = Analytical::KissMetrics::Api.new @parent, {:key=>'abcdef'}
      @api.event('Big Deal', {:something=>'good'}).should == "_kmq.push([\"record\", \"Big Deal\", #{{:something=>'good'}.to_json}]);"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::KissMetrics::Api.new @parent, {:key=>'abcdef'}
      @api.init_javascript(:head).should == ''
      @api.init_javascript(:body_prepend).should =~ /scripts.kissmetrics.com/
      @api.init_javascript(:body_prepend).should =~ /abcdef/      
      @api.init_javascript(:body_append).should == ''
    end
  end
end
