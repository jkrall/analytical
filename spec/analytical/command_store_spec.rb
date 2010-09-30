require 'spec_helper'

describe Analytical::CommandStore do
  
  describe 'when behaving exactly like an array' do
    it 'should add elements' do
      @store = Analytical::CommandStore.new ['a']
      @store << 'b'
      @store.commands.should == ['a', 'b']
    end
    it 'should unshift elements' do
      @store = Analytical::CommandStore.new ['b']
      @store.unshift 'a'
      @store.commands.should == ['a', 'b']
    end
    it 'should iterate over elements' do
      @store = Analytical::CommandStore.new ['a', 'b']
      @store.each do |elem|
        ['a', 'b'].include?(elem).should be_true
      end
    end
    it 'should have size' do
      @store = Analytical::CommandStore.new ['a', 'b']
      @store.size.should == 2
    end
  end
  
  describe 'when flushing' do
    it 'should empty the list' do
      @store = Analytical::CommandStore.new ['a', 'b']
      @store.flush
      @store.size.should == 0
    end
  end
  
end
