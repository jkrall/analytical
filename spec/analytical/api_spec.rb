require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Api" do

  describe 'on initialization' do
    it 'should construct an api class for each module' do
      Analytical::Console::Api.should_receive(:new).and_return(@console = mock('console'))
      Analytical::Google::Api.should_receive(:new).and_return(@google = mock('google'))
      a = Analytical::Api.new :modules=>[:console, :google]
      a.modules.should == {
        :console=>{:api=>@console, :commands => [], :initialized => false}, 
        :google=>{:api=>@google, :commands => [], :initialized => false}, 
      }
    end
  end

  describe 'with modules' do
    before(:each) do
      Analytical::Console::Api.stub!(:new).and_return(@console = mock('console'))
      Analytical::Google::Api.stub!(:new).and_return(@google = mock('google'))
      @api = Analytical::Api.new :modules=>[:console, :google]
    end

    describe '#track' do
      it 'should call #track on each module api class that is preinitialized' do
        @console.should_receive(:track).with('something', {:a=>1, :b=>2})
        @api.modules[:console][:initialized] = true
        @google.should_not_receive(:track)
        @api.track('something', {:a=>1, :b=>2})
      end
      it 'should store the #track command for each module api class that is not preinitialized' do
        Analytical::Clicky::Api.stub!(:new).and_return(@clicky = mock('clicky'))      
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky]
              
        @console.stub!(:track).and_return('console track called')
        @api.modules[:console][:initialized] = true
        @clicky.stub!(:track).and_return('clicky track called')
        @api.modules[:clicky][:initialized] = true
        @google.should_not_receive(:track)
        
        @api.track('something', {:a=>1, :b=>2}).should == "console track called\nclicky track called"
        @api.track('something 2', {:a=>3, :b=>4}).should == "console track called\nclicky track called"
        
        @api.modules[:google][:commands].should == [
          [:track, 'something', {:a=>1, :b=>2}],
          [:track, 'something 2', {:a=>3, :b=>4}],          
        ]
        @api.modules[:console][:commands].should == []
        @api.modules[:clicky][:commands].should == []        
      end
    end
    
    describe 'gathering javascript' do
      before(:each) do
        @console.should_receive(:init_javascript).and_return(:head=>'console_a', :body_prepend=>'console_b', :body_append=>'console_c')
        @console.stub!(:tracking_command_location).and_return(:body_prepend)
        @google.should_receive(:init_javascript).and_return(:head=>'google_a', :body_prepend=>'google_b', :body_append=>'google_c')
        @google.stub!(:tracking_command_location).and_return(:body_prepend)        
      end
      describe '#head_javascript' do
        it 'should return the javascript' do
          @api.head_javascript.should == "console_a\ngoogle_a"
        end
      end
      describe '#body_prepend_javascript' do
        it 'should return the javascript' do
          @api.body_prepend_javascript.should == "console_b\ngoogle_b"
        end
      end
      describe '#body_append_javascript' do
        it 'should return the javascript' do
          @api.body_append_javascript.should == "console_c\ngoogle_c"
        end
      end
      describe 'with stored commands' do
        before(:each) do
          @console.stub!(:track).and_return('console track called')
          @google.stub!(:track).and_return('google track called')
          @api.track('something', {:a=>1, :b=>2})
        end
        describe '#body_prepend_javascript' do
          it 'should return the javascript' do
            @api.body_prepend_javascript.should == "console_b\ngoogle_b\nconsole track called\ngoogle track called"
          end
        end
      end
    end
  end



end
