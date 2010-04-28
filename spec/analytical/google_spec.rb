require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Google::Api" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Google::Api.new @parent, {:key=>'abc'}
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::Google::Api.new @parent, {:key=>'abc'}
      a.options.should == {:key=>'abc'}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Google::Api.new @parent, {:key=>'abcdef'}
      @api.track('pagename', {:some=>'data'}).should == "googleAnalyticsTracker._trackPageview('pagename');"
    end
  end
  describe '#identify' do
    it 'should return an empty string' do
      @api = Analytical::Google::Api.new @parent, {:key=>'abcdef'}
      @api.identify('nothing', {:matters=>'at all'}).should == ''
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Google::Api.new @parent, {:key=>'abcdef'}
      @api.init_javascript[:head].should be_nil
      @api.init_javascript[:body_prepend].should =~ /google-analytics.com\/ga.js/
      @api.init_javascript[:body_prepend].should =~ /abcdef/      
      @api.init_javascript[:body_append].should be_nil            
    end
  end
end
