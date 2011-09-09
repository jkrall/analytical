require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Clicky" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abcdef'
      @api.track('pagename', {:some=>'data'}).should == "clicky.log(\"pagename\");"
    end
  end
  describe '#identify' do
    it 'should return the init code string' do
      @api = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abcdef'
      @api.identify('user id', {:a=>'b'}).should =~ /#{Regexp.escape({:id=>'user id', :a=>'b'}.to_json)}/
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''            
      @api.init_javascript(:body_append).should =~ /static.getclicky.com\/js/
      @api.init_javascript(:body_append).should =~ /abcdef/      
    end
    describe 'with an identify command queued' do
      @api = Analytical::Modules::Clicky.new :parent=>@parent, :key=>'abcdef'
      @api.queue :identify, 'user id', {:email=>'someone@test.com'}
      @api.init_javascript(:body_append).should =~ /"email":\w*"someone@test\.com"/
    end
  end
end
