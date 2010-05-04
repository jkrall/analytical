require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe "Analytical" do
  before(:each) do
    rails_env = mock('rails environment', :'production?'=>true, :'development?'=>false)
    Rails.stub!(:env).and_return(rails_env)
    File.stub!(:'exists?').and_return(false)
  end

  describe 'on initialization' do
    class DummyForInit
      extend Analytical
      def self.helper_method(*a); end
      def request
        Spec::Mocks::Mock.new 'request', 
          :'ssl?'=>true, 
          :user_agent=>'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3 GTB7.0'
      end
    end

    it 'should have the default options' do
      DummyForInit.analytical
      d = DummyForInit.new.analytical
      d.options[:modules].should == []
      d.options[:development_modules].should == [:console]
      d.options[:disable_if].call.should be_false
    end

    it 'should use the supplied options' do
      DummyForInit.analytical :modules=>[:google]
      d = DummyForInit.new.analytical
      d.options[:modules].should == [:google]
      d.options[:development_modules].should == [:console]
      d.options[:disable_if].call.should be_false
    end
    
    describe 'with a robot request' do
      it 'should set the modules to []' do
        DummyForInit.analytical
        d = DummyForInit.new
        d.stub!(:'analytical_is_robot?').and_return(true)
        d.analytical.options[:modules].should == []
      end
    end

    it 'should open the initialization file' do
      File.should_receive(:'exists?').with("#{RAILS_ROOT}/config/analytical.yml").and_return(true)
      DummyForInit.analytical
      DummyForInit.analytical_options[:google].should == {:key=>'google_12345'}
      DummyForInit.analytical_options[:kiss_metrics].should == {:key=>'kiss_metrics_12345'}
      DummyForInit.analytical_options[:clicky].should == {:key=>'clicky_12345'}            
    end

    describe 'in production mode' do
      before(:each) do
        Rails.env.stub!(:production?).and_return(true)
      end
      it 'should start with no modules' do
        Analytical::Api.should_not_receive(:include)
        DummyForInit.analytical
        DummyForInit.new.analytical.options[:modules] = []
      end
    end

    describe 'in development mode' do
      before(:each) do
        Rails.env.stub!(:production?).and_return(false)
      end
      it 'should start with no modules' do
        DummyForInit.analytical
        DummyForInit.new.analytical.options[:modules] = [:console]
      end
    end

  end

end
