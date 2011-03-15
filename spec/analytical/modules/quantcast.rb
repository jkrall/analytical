require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Quantcast" do
  before(:each) do
    @parent = mock('api', :options=>{:quantcast=>{:key=>1234}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Quantcast.new :parent=>@parent, :key=>1234
      a.tracking_command_location.should == [:head_append, :body_append]
    end
    it 'should set the options' do
      a = Analytical::Modules::Quantcast.new :parent=>@parent, :key=>12345
      a.options.should == {:key=>12345, :parent=>@parent}
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Quantcast.new :parent=>@parent, :key=>12345
      @api.init_javascript(:head_prepend).should =~ ''
      @api.init_javascript(:head_append).should == /var._qevents.=._qevents.\|\|.\[\];/
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should =~ /_qevents.push\(.\{.qacct:"12345"\} \);/
    end
  end
end