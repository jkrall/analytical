require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Reinvigorate" do

  before(:each) do
    @parent = mock('api', :options=>{:reinvigorate=>{:key=>'abc'}})
  end

  describe 'on initialize' do

    it 'should set the command_location' do
      a = Analytical::Modules::Reinvigorate.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :body_append
    end

    it 'should set the options' do
      a = Analytical::Modules::Reinvigorate.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end

  end

  describe '#init_javascript' do

    it 'should return the init javascript' do
      @api = Analytical::Modules::Reinvigorate.new :parent=>@parent, :key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ /reinvigorate/
    end

  end

end