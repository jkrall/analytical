require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Comscore" do
  before(:each) do
    @parent = mock('api', :options=>{:comscore=>{:key=>123}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Comscore.new :parent=>@parent, :key=>123
      a.tracking_command_location.should == :head_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Comscore.new :parent=>@parent, :key=>1234
      a.options.should == {:key=>1234, :parent=>@parent}
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Comscore.new :parent=>@parent, :key=>1234
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should =~ /scorecardresearch.com\/beacon.js/
      @api.init_javascript(:head_append).should =~ /1234/
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should == ''
    end
  end
end