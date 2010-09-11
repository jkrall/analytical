require 'spec_helper'

describe Analytical::SessionCommandStore do
  
  describe 'with a session hash' do
    before(:each) do
      @session = {}
    end
    
    it 'should add elements' do
      @store = Analytical::SessionCommandStore.new @session, :some_module, ['a']
      @store << 'b'
      @session[:analytical_some_module].should == ['a', 'b']
    end
    it 'should unshift elements' do
      @store = Analytical::SessionCommandStore.new @session, :some_module, ['b']
      @store.unshift 'a'
      @session[:analytical_some_module].should == ['a', 'b']
    end
    it 'should iterate over elements' do
      @store = Analytical::SessionCommandStore.new @session, :some_module, ['a', 'b']
      @store.each do |elem|
        ['a', 'b'].include?(elem).should be_true
      end
    end
    it 'should have size' do
      @store = Analytical::SessionCommandStore.new @session, :some_module, ['a', 'b']
      @store.size.should == 2
    end

    it 'should set up the :analytical session hash' do
      @store = Analytical::SessionCommandStore.new @session, :some_module, ['a', 'b']
      @session[:analytical_some_module].should_not be_nil   
    end

    describe 'when flushing' do
      it 'should empty the list' do
        @store = Analytical::SessionCommandStore.new @session, :some_module, ['a', 'b']
        @store.flush
        @store.size.should == 0
      end
      it 'should empty the session key' do
        @store = Analytical::SessionCommandStore.new @session, :some_module, ['a', 'b']
        @store.flush
        @session[:analytical_some_module].should == []
      end
    end
  end
  
end
