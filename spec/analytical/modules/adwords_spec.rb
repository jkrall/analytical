require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Adwords" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :body_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end
  end
  describe '#event' do
    it 'should return an empty string' do
      @api = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abcdef'
      @api.event('Nothing', {:some=>'data'}).should == ''
    end
  end
  describe '#init_javascript' do
    describe 'when a matching conversion event is not found' do
      it 'should return the event js' do
        @api = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abcdef'
        @api.queue :event, 'Nothing', {:some=>'data'}
        @api.init_javascript(:body_append).should.should =~ /<!-- No Adwords Conversion for: Nothing -->/
      end
    end
    describe 'for a given conversion event' do
      before(:each) do
        @api = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abcdef', :'TheBigEvent'=>{
          :id=>'55555',
          :language=>'en',
          :format=>'2',
          :color=>'ffffff',
          :label=>'abcdef',
          :value=>'0',
        }
      end
      it 'should return the event js' do
        @api.queue :event, 'TheBigEvent'
        body_append = @api.init_javascript(:body_append).should
        body_append.should =~ /google_conversion_id = 55555/m
        body_append.should =~ /google_conversion_language = "en";/m
        body_append.should =~ /google_conversion_format = "2";/m
        body_append.should =~ /google_conversion_color = "ffffff";/m
        body_append.should =~ /google_conversion_label = "abcdef";/m
        body_append.should =~ /google_conversion_value = 0;/m
        body_append.should =~ /http:\/\/www.googleadservices.com\/pagead\/conversion.js/m
      end
      describe 'with a custom value' do
        it 'should return the event js' do
          @api.queue :event, 'TheBigEvent', :value=>666.66
          body_append = @api.init_javascript(:body_append).should
          body_append.should =~ /google_conversion_value = 666.66;/m
        end
      end
      describe 'for https' do
        it 'should return the event js' do
          @api = Analytical::Modules::Adwords.new :parent=>@parent, :key=>'abcdef', :ssl=>true, :'TheBigEvent'=>{
            :id=>'55555',
            :language=>'en',
            :format=>'2',
            :color=>'ffffff',
            :label=>'abcdef',
            :value=>'0',
          }
          @api.queue :event, 'TheBigEvent'
          @api.init_javascript(:body_append).should =~ /https:\/\/www.googleadservices.com\/pagead\/conversion.js/
        end
      end
    end
  end
end
