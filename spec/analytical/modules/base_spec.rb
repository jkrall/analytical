require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Analytical::Modules::Base do

  class BaseApiDummy
    include Analytical::Modules::Base
  end

  describe '#protocol' do
    before(:each) do
      @api = BaseApiDummy.new(:parent=>mock('parent'))
    end
    describe 'with :ssl=>true option' do
      it 'should return https' do
        @api = BaseApiDummy.new(:parent=>mock('parent'), :ssl=>true)
        @api.protocol.should == 'https'
      end
    end
    it 'should return http' do
      @api.protocol.should == 'http'
    end
  end

  describe '#queue' do
    before(:each) do
      @api = BaseApiDummy.new(:parent=>mock('parent'))
      @api.command_store.commands = [:a, :b, :c]
    end
    describe 'with an identify command' do
      it 'should store it at the head of the command list' do
        @api.queue :identify, 'someone', {:some=>:args}
        @api.command_store.commands.should == [[:identify, 'someone', {:some=>:args}], :a, :b, :c]
      end
    end
    describe 'with any other command' do
      it 'should store it at the end of the command list' do
        @api.queue :other, {:some=>:args}
        @api.command_store.commands.should == [:a, :b, :c, [:other, {:some=>:args}]]
      end
    end
    describe 'ignoring duplicates' do
      before(:each) do
        @api = BaseApiDummy.new(:parent=>mock('parent'), :ignore_duplicates=>true)
        @api.command_store.commands = [[:a]]
      end
      it 'should store only unique commands' do
        @api.queue :other, {:some=>:args}
        @api.queue :a
        @api.queue :other, {:some=>:args}
        @api.queue :b
        @api.command_store.commands.should == [[:a], [:other, {:some=>:args}], [:b]]
      end
    end
  end

  describe '#process_queued_commands' do
    before(:each) do
      @api = BaseApiDummy.new(:parent=>mock('parent'))
      @api.command_store.commands = [[:a, 1, 2, 3], [:b, {:some=>:args}]]
      @api.stub!(:a).and_return('a')
      @api.stub!(:b).and_return('b')
    end
    it 'should send each of the args arrays in the command list' do
      @api.should_receive(:a).with(1, 2, 3).and_return('a')
      @api.should_receive(:b).with({:some=>:args}).and_return('b')
      @api.process_queued_commands
    end
    it 'should return the results as an array' do
      @api.process_queued_commands.should == ['a', 'b']
    end
    it 'should clear the commands list' do
      @api.process_queued_commands
      @api.command_store.commands == []
    end
    it "should not store an unrecognized command" do
      @api.command_store.commands << [:c, 1]
      @api.process_queued_commands.should == ['a','b']
    end
  end

  describe '#init_location?' do
    before(:each) do
      @api = BaseApiDummy.new(:parent=>mock('parent'))
      @api.instance_variable_set '@tracking_command_location', :my_location
    end
    describe 'when the command location matches the init location' do
      it 'should return true' do
        @api.init_location?(:my_location).should be_true
      end
    end
    describe 'when the command location does not match the init location' do
      it 'should return false' do
        @api.init_location?(:not_my_location).should be_false
      end
    end
  end

  describe '#init_location' do
    before(:each) do
      @api = BaseApiDummy.new
    end
    it 'should check for the init_location' do
      @api.should_receive(:init_location?).with(:some_location).and_return(false)
      @api.init_location(:some_location)
    end
    describe 'for a valid init location' do
      before(:each) { @api.stub!(:init_location?).and_return(true) }
      it 'should set initialized to true' do
        @api.init_location(:some_location)
        @api.initialized.should be_true
      end
      it 'should yield to the block and return its result' do
        @api.init_location(:some_location) do
          'result from the block'
        end.should == 'result from the block'
      end
    end
    describe 'not for an init location' do
      before(:each) do
        @api.stub!(:init_location?).and_return(false)
      end
      it 'should return an empty string' do
        @api.init_location(:not_my_init_location).should == ''
      end
    end
  end

  describe 'with a custom session_store' do
    before(:each) do
      @session = {}
      @store = Analytical::SessionCommandStore.new @session, :some_module
    end
    it 'should use the session_store' do
      @api = BaseApiDummy.new :session_store=>@store
      @api.command_store.should == @store
    end
  end
end
