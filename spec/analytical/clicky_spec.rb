require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Clicky::Api" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Clicky::Api.new @parent, {:key=>'abc'}
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Clicky::Api.new @parent, {:key=>'abc'}
      a.options.should == {:key=>'abc'}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Clicky::Api.new @parent, {:key=>'abcdef'}
      @api.track('pagename', {:some=>'data'}).should == "clicky.log(\"pagename\");"
    end
  end
  describe '#identify' do
    it 'should return the init code string' do
      @api = Analytical::Clicky::Api.new @parent, {:key=>'abcdef'}
      @api.identify('user id', {:a=>'b'}).should =~ /#{Regexp.escape({:id=>'user id', :a=>'b'}.to_json)}/
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Clicky::Api.new @parent, {:key=>'abcdef'}
      @api.init_javascript[:head].should be_nil
      @api.init_javascript[:body_prepend].should be_nil            
      @api.init_javascript[:body_append].should =~ /static.getclicky.com\/js/
      @api.init_javascript[:body_append].should =~ /abcdef/      
    end
    describe 'for an ssl connection' do
      it 'should return the ssl init code' do
        @api = Analytical::Clicky::Api.new @parent, {:key=>'abcdef', :ssl=>true}
        @api.init_javascript[:body_append].should =~ /https/
      end
    end
    describe 'with an identify command queued' do
      @api = Analytical::Clicky::Api.new @parent, {:key=>'abcdef'}
      @api.queue :identify, 'user id', {:email=>'someone@test.com'}
      @api.init_javascript[:body_append].should =~ /"email":\w*"someone@test\.com"/
    end
  end
end
