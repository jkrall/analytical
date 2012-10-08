require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe "Analytical" do
  describe 'on initialization' do
    class DummyForInit
      extend Analytical
      include Analytical::InstanceMethods
      include Analytical::BotDetector
      if ::Rails::VERSION::MAJOR < 3
        class_inheritable_accessor :analytical_options
      else
        class_attribute :analytical_options
      end

      def self.helper_method(*a); end
      def request
        RSpec::Mocks::Mock.new 'request', 
          :'ssl?'=>true, 
          :user_agent=>'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3 GTB7.0'
      end
    end

    it 'should have the options from analytical.yml' do
      DummyForInit.analytical
      d = DummyForInit.new.analytical
      d.options[:modules].sort_by { |m| m.to_s }.should == [:chartbeat, :clicky, :google, :kiss_metrics]
      d.options[:true_option].should be_true
      d.options[:false_option].should be_false
      d.options[:string_option].should == "string"
    end

    it 'should use the supplied options' do
      DummyForInit.analytical :modules=>[:google]
      d = DummyForInit.new.analytical
      d.options[:modules].should == [:google]
    end
    
    describe 'conditionally disabled' do
      it 'should set the modules to []' do
        DummyForInit.analytical :disable_if => lambda { |x| true }
        d = DummyForInit.new
        d.analytical.options[:modules].should == []        
      end
    end

    describe 'with filtered modules' do
      it 'should set the modules to []' do
        DummyForInit.analytical :filter_modules => lambda { |x, modules| modules - [:clicky] }
        d = DummyForInit.new
        d.analytical.options[:modules].include?(:clicky).should be_false
      end
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
      File.should_receive(:'exists?').with("#{Rails.root}/config/analytical.yml").and_return(true)
      DummyForInit.analytical
      DummyForInit.analytical_options[:google].should == {:key=>'google_12345'}
      DummyForInit.analytical_options[:kiss_metrics].should == {:key=>'kiss_metrics_12345'}
      DummyForInit.analytical_options[:clicky].should == {:key=>'clicky_12345'}
      DummyForInit.analytical_options[:chartbeat].should == {:key=>'chartbeat_12345', :domain => 'your.domain.com'}
    end

    it 'should allow for module-specific controller overrides' do
      DummyForInit.analytical :google=>{:key=>'override_google_key'}
      DummyForInit.analytical_options[:google].should == {:key=>'override_google_key'}
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

    describe 'in non-production mode' do
      before(:each) do
        Rails.env.stub!(:production?).and_return(false)
      end
      it 'should start with no modules' do
        DummyForInit.analytical
        DummyForInit.new.analytical.options[:modules] = [:console]
      end
    end

    describe 'in development mode' do
      before(:each) do
        Rails.stub!(:env).and_return(:development)
      end
      it 'should start with no modules' do
        DummyForInit.analytical
        DummyForInit.new.analytical.options[:modules] = []
      end
    end

  end

end
