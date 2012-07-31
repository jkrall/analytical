require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Gauges" do
  before(:each) do
    @parent = mock('api', :options=>{:gauges=>{:site_id=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Gauges.new :parent=>@parent, :site_id=>'abc'
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Gauges.new :parent=>@parent, :site_id=>'abc'
      a.options.should == {:site_id=>'abc', :parent=>@parent}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Gauges.new :parent=>@parent, :site_id=>'abcdef'
      @api.track.should == "_gauges.push(['track']);"
      @api.track('pagename', {:some=>'data'}).should ==  "_gauges.push(['track']);"
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Gauges.new :parent=>@parent, :site_id=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ /secure\.gaug\.es/
      @api.init_javascript(:body_append).should =~ /abcdef/
    end
  end
end
