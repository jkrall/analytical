require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::GoogleTagManager" do
  let(:parent) { mock('api', options: {google_tag_manager: {key: 'abc'}}) }
  let(:analytical) { Analytical::Modules::GoogleTagManager.new parent: @parent, key: 'abc' }

  describe 'on initialize' do
    it 'sets default tracking command location' do
      expected = {
        init_javascript: [:head_prepend, :body_prepend],
        event: :body_append,
        track: :body_append,
        set: :head_append,
        track_page: :body_append,
        key_interaction: :body_append
      }
      expect(analytical.tracking_command_location).to eq expected
    end

    it 'sets the options' do
      expect(analytical.options).to eq({key: 'abc', parent: @parent})
    end
  end

  describe '#event' do
    it 'returns a js string' do
      expected =
        <<-HTML
        var dataLayerEventData = {"something":"good"};
        dataLayerEventData['event'] = "Big Deal";
        dataLayer.push(dataLayerEventData);
        HTML
      expect(analytical.event('Big Deal', {:something=>'good'})).to eq expected
    end
  end

  describe '#init_javascript' do
    it 'returns the init javascript' do
      expect(analytical.init_javascript(:head_prepend)).to match(/"ga_id":"abc"/)
      expect(analytical.init_javascript(:head_append)).to eq ''
      expect(analytical.init_javascript(:body_prepend)).to match(/googletagmanager\.com/)
      expect(analytical.init_javascript(:body_prepend)).to match(/w,d,s,l,i/)
      expect(analytical.init_javascript(:body_append)).to eq ''
    end
  end

  describe '#track' do
    it 'returns a js string' do
      expected = "dataLayer.push({ 'page_virtualName': \"/page\", 'event': 'gtm.view' });"
      expect(analytical.track('/page')).to eq expected
    end
  end

  describe '#set' do
    it 'returns a js string' do
      expected = "dataLayer.push({\"something\":\"good\"});"
      expect(analytical.set({something: 'good'})).to eq expected
    end
  end
end

