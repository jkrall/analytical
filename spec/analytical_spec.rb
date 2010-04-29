require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe "Analytical" do
  before(:each) do
    rails_env = mock('rails environment', :'production?'=>true, :'development?'=>false)
    Rails.stub!(:env).and_return(rails_env)
  end

  describe 'on initialization' do
    class DummyForInit
      extend Analytical
      def request; OpenStruct.new(:'ssl?'=>true); end
      def self.helper_method(*a); end
    end

    it 'should have the default options' do
      DummyForInit.analytical
      d = DummyForInit.new.analytical
      d.options[:modules].should == []
      d.options[:development_modules].should == [:console]
      d.options[:disable_if].call.should be_false
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
      it 'should include specific modules' do
        Analytical::Api.should_receive(:include).with(Analytical::Console)
        Analytical::Api.should_receive(:include).with(Analytical::Google)
        DummyForInit.analytical :modules=>[:google, :console]
        DummyForInit.new.analytical.options[:modules] = [:google, :console]
      end
    end

    describe 'in development mode' do
      before(:each) do
        Rails.env.stub!(:production?).and_return(false)
      end
      it 'should start with no modules' do
        Analytical::Api.should_receive(:include).with(Analytical::Console)
        DummyForInit.analytical
        DummyForInit.new.analytical.options[:modules] = [:console]
      end
    end

  end

end
