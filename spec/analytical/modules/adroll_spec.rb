require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Adroll" do
  before(:each) do
    @parent = mock('api', :options=>{:Adroll=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Adroll.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Adroll.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end
  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Adroll.new :parent=>@parent, :adv_id=>'abcdef', :pix_id=>'123456'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_append).should =~ /abcdef/
      @api.init_javascript(:body_append).should =~ /123456/
      @api.init_javascript(:body_append).should =~ /adroll\.com/
    end
  end
end