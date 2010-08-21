require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Chartbeat::Api" do
  before(:each) do
    @parent = mock('api', :options=>{:chartbeat=>{:key=>1234, :domain =>'test.com'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Chartbeat::Api.new @parent, {:key=>1234}
      a.tracking_command_location.should == [:head_prepend, :body_append]
    end
    it 'should set the options' do
      a = Analytical::Chartbeat::Api.new @parent, {:key=>12345, :domain =>'abcdef.com'}
      a.options.should == {:key=>12345, :domain => 'abcdef.com'}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Chartbeat::Api.new @parent, {:key=>12345}
      @api.track.should == ''
    end
  end
  describe '#identify' do
    it 'should return an empty string' do
      @api = Analytical::Chartbeat::Api.new @parent, {:key=>12345}
      @api.identify('nothing', {:matters=>'at all'}).should == ''
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Chartbeat::Api.new @parent, {:key=>12345, :domain =>'abcdef.com'}
      @api.init_javascript(:head_prepend).should =~ /_sf_startpt=\(new.Date\(\)\)\.getTime\(\);/
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ /_sf_async_config=\{uid:12345,.*domain:"abcdef\.com"\};/
    end
  end
end