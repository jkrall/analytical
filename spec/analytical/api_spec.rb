require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Analytical::Api" do

  describe 'on initialization' do
    it 'should construct an api class for each module' do
      Analytical::Modules::Console.should_receive(:new).and_return(@console = mock('console'))
      Analytical::Modules::Google.should_receive(:new).and_return(@google = mock('google'))
      a = Analytical::Api.new :modules=>[:console, :google]
      a.modules.should == {
        :console=>@console,
        :google=>@google,
      }
    end
    it 'should pass the ssl option on to the module constructor' do
      Analytical::Modules::Console.should_receive(:new).with(hash_including(:ssl=>true)).and_return(@console = mock('console'))
      Analytical::Api.new :modules=>[:console], :ssl=>true
    end
    describe 'with a session option' do
      before(:each) do
        @session = {}
      end
      it 'should create a new SessionCommandStore for each module' do
        Analytical::SessionCommandStore.should_receive(:new).with(@session, :console).and_return(@console_store = mock('console_store'))
        Analytical::SessionCommandStore.should_receive(:new).with(@session, :google).and_return(@google_store = mock('google_store'))        
        Analytical::Modules::Console.should_receive(:new).with(:session_store=>@console_store, :session=>@session).and_return(mock('console'))
        Analytical::Modules::Google.should_receive(:new).with(:session_store=>@google_store, :session=>@session).and_return(mock('google'))
        Analytical::Api.new :modules=>[:console, :google], :session=>@session
      end
    end
  end

  describe 'with modules' do
    before(:each) do
      Analytical::Modules::Console.stub!(:new).and_return(@console = mock('console'))
      Analytical::Modules::Google.stub!(:new).and_return(@google = mock('google'))
      Analytical::Modules::Clicky.stub!(:new).and_return(@clicky = mock('clicky'))
      Analytical::Modules::Chartbeat.stub!(:new).and_return(@chartbeat = mock('chartbeat'))

      @api = Analytical::Api.new :modules=>[:console, :google]
    end

    describe '#track' do
      it 'should store the #track command for each module api class' do
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky]

        @console.should_receive(:queue).with(:track, 'something', {:a=>1, :b=>2})
        @clicky.should_receive(:queue).with(:track, 'something', {:a=>1, :b=>2})
        @google.should_receive(:queue).with(:track, 'something', {:a=>1, :b=>2})

        @api.track('something', {:a=>1, :b=>2})
      end
    end

    describe '#identify' do
      it 'should store the #track command for each module api class' do
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky]

        @console.should_receive(:queue).with(:identify, 'something', {:a=>1, :b=>2})
        @clicky.should_receive(:queue).with(:identify, 'something', {:a=>1, :b=>2})
        @google.should_receive(:queue).with(:identify, 'something', {:a=>1, :b=>2})

        @api.identify('something', {:a=>1, :b=>2})
      end
    end

    describe '#now' do
      it 'should call a command on each module and collect the results' do
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky]

        @console.should_receive(:track).with('something', {:a=>1, :b=>2}).and_return('console track')
        @clicky.should_receive(:track).with('something', {:a=>1, :b=>2}).and_return('clicky track')
        @google.should_receive(:respond_to?).with(:track).and_return(false)
        @google.should_not_receive(:track)

        @api.now.track('something', {:a=>1, :b=>2}).should == "console track\nclicky track"
      end
    end

    describe 'when accessing a module by name' do
      it 'should return the module api object' do
        @api = Analytical::Api.new :modules=>[:console, :google, :clicky, :chartbeat]
        @api.console.should == @console
        @api.clicky.should == @clicky
        @api.google.should == @google
        @api.chartbeat.should == @chartbeat
      end
    end

    describe 'gathering javascript' do
      before(:each) do
        @console.stub!(:init_location?).and_return(false)
        @console.stub!(:initialized).and_return(false)
        @console.stub!(:process_queued_commands).and_return([])
        @google.stub!(:init_location?).and_return(false)
        @google.stub!(:initialized).and_return(false)
        @google.stub!(:process_queued_commands).and_return([])
      end

      describe '#head_prepend_javascript' do
        it 'should return the javascript' do
          @console.should_receive(:init_javascript).with(:head_prepend).and_return('console_a')
          @google.should_receive(:init_javascript).with(:head_prepend).and_return('google_a')
          @api.head_prepend_javascript.should == "console_agoogle_a"
        end
      end

      describe '#head_append_javascript' do
        it 'should return the javascript' do
          @console.should_receive(:init_javascript).with(:head_append).and_return('console_a')
          @google.should_receive(:init_javascript).with(:head_append).and_return('google_a')
          @api.head_append_javascript.should == "console_agoogle_a"
        end
        it 'should render an existing template for Rails 3.0' do
          @api.options[:javascript_helpers] = true
          (@api.options[:controller] ||= Object.new).stub!(:render_to_string) { |param| param[:file] }
          File.exist?(@api.head_append_javascript).should be_true
        end
        it 'should not render an existing template if javascript_helpers is false' do
          @api.options[:javascript_helpers] = false
          (@api.options[:controller] ||= Object.new).should_not_receive(:render_to_string)
          @api.head_append_javascript.should be_blank
        end
      end
      
      describe '#body_prepend_javascript' do
        it 'should return the javascript' do
          @console.should_receive(:init_javascript).with(:body_prepend).and_return('console_b')
          @google.should_receive(:init_javascript).with(:body_prepend).and_return('google_b')
          @api.body_prepend_javascript.should == "console_bgoogle_b"
        end
      end
      describe '#body_append_javascript' do
        it 'should return the javascript' do
          @console.should_receive(:init_javascript).with(:body_append).and_return('console_c')
          @google.should_receive(:init_javascript).with(:body_append).and_return('google_c')
          @api.body_append_javascript.should == "console_cgoogle_c"
        end
      end
      describe 'with stored commands' do
        before(:each) do
          @console.stub!(:init_location?).and_return(true)
          @console.stub!(:initialized).and_return(false)
          @console.stub!(:track).and_return('console track called')
          @console.stub!(:queue)
          @console.stub!(:process_queued_commands).and_return(['console track called'])
          @google.stub!(:init_location?).and_return(false)
          @google.stub!(:initialized).and_return(true)
          @google.stub!(:track).and_return('google track called')
          @google.stub!(:queue)
          @google.stub!(:process_queued_commands).and_return(['google track called'])
          @api.track('something', {:a=>1, :b=>2})
        end
        describe '#body_prepend_javascript' do
          it 'should return the javascript' do
            @console.should_receive(:init_javascript).with(:body_prepend).and_return('console_b')
            @google.should_receive(:init_javascript).with(:body_prepend).and_return('google_b')
            @api.body_prepend_javascript.should == "console_bgoogle_b\n<script type='text/javascript'>\nconsole track called\ngoogle track called\n</script>"
          end
        end
      end
    end
  end



end
