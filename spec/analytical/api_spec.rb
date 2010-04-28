require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Api" do

  describe 'on initialization' do
    it 'should construct an api class for each module' do
      Analytical::Console::Api.should_receive(:new).and_return(@console = mock('console'))
      Analytical::Google::Api.should_receive(:new).and_return(@google = mock('google'))
      a = Analytical::Api.new :modules=>[:console, :google]
      a.modules.should == {
        :console=>{:api=>@console, :initialized => false}, 
        :google=>{:api=>@google, :initialized => false}, 
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
        @api.modules[:console][:initialized] = true
        @console.should_receive(:track).with('something', {:a=>1, :b=>2})
        @google.should_not_receive(:track)
        @google.should_receive(:queue).with(:track, 'something', {:a=>1, :b=>2})
        @api.track('something', {:a=>1, :b=>2})
      end
      it 'should store the #track command for each module api class that is not preinitialized' do
        Analytical::Clicky::Api.stub!(:new).and_return(@clicky = mock('clicky'))      
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky]
              
        @api.modules[:console][:initialized] = true
        @api.modules[:clicky][:initialized] = true
        @console.stub!(:track).and_return('console track called')
        @console.should_not_receive(:queue)
        @clicky.stub!(:track).and_return('clicky track called')
        @clicky.should_not_receive(:queue)

        @google.should_not_receive(:track)
        @google.should_receive(:queue).with(:track, 'something', {:a=>1, :b=>2})
        @google.should_receive(:queue).with(:track, 'something 2', {:a=>3, :b=>4})        
        
        @api.track('something', {:a=>1, :b=>2}).should == "console track called\nclicky track called"
        @api.track('something 2', {:a=>3, :b=>4}).should == "console track called\nclicky track called"
      end
    end
    
    describe 'gathering javascript' do
      before(:each) do
        @console.should_receive(:init_javascript).and_return(:head=>'console_a', :body_prepend=>'console_b', :body_append=>'console_c')
        @console.stub!(:tracking_command_location).and_return(:body_prepend)
        @console.stub!(:process_queued_commands).and_return([])
        @google.should_receive(:init_javascript).and_return(:head=>'google_a', :body_prepend=>'google_b', :body_append=>'google_c')
        @google.stub!(:tracking_command_location).and_return(:body_prepend)
        @google.stub!(:process_queued_commands).and_return([])
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
          @console.stub!(:queue)
          @console.stub!(:process_queued_commands).and_return(['console track called'])          
          @google.stub!(:track).and_return('google track called')
          @google.stub!(:queue)          
          @google.stub!(:process_queued_commands).and_return(['google track called'])          
          @api.track('something', {:a=>1, :b=>2})
        end
        describe '#body_prepend_javascript' do
          it 'should return the javascript' do
            @api.body_prepend_javascript.should == "console_b\ngoogle_b\n<script type='text/javascript'>\nconsole track called\ngoogle track called\n</script>"
          end
          it 'should mark the modules as initialized' do
            @api.body_prepend_javascript.should == "console_b\ngoogle_b\n<script type='text/javascript'>\nconsole track called\ngoogle track called\n</script>"
            @api.track('something', {:a=>1, :b=>2}).should == "console track called\ngoogle track called"
          end
        end
      end
    end
  end



end
