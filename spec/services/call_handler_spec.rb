require 'rails_helper'

RSpec.describe CallHandler do
  let(:call_sid) { SecureRandom.uuid }
  let(:params) { { action: action, CallSid: call_sid } }
  let(:action) { nil } # Controller action name
  subject(:handler) { CallHandler.new(params) }

  describe '#initialize' do
    it 'initializes the handler with parameters' do
      instance = CallHandler.new(params)
      expect(instance.params).to be(params)
    end
  end

  describe '#response_text' do
    context 'Top-Level Menu' do
      let(:action) { 'menu' }

      it 'returns twiml for the top-level menu' do
        menu_twiml = handler.response_text
        document = Nokogiri::XML(menu_twiml)

        gather_node = document.at_xpath('.//Gather')

        expect(gather_node[:numDigits]).to eq('1')
        expect(gather_node[:action]).to eq('/calls/menu_option_select')
        expect(gather_node[:method]).to eq('POST')
        expect(gather_node[:timeout]).to eq('30')

        play_node = gather_node.at_xpath('./Play')
        expect(play_node.text).to eq('/audio/introduction.mp3')
      end
    end

    context 'Menu Select' do
      context 'Create a Droplet' do
        let(:action) { 'menu_option_select' }
        let(:params) { super().merge(Digits: '1') }

        it 'redirects to the droplet regions selection menu' do
          menu_twiml = handler.response_text
          document = Nokogiri::XML(menu_twiml)

          redirect_node = document.at_xpath('.//Redirect')
          expect(redirect_node[:method]).to eq('GET')
          expect(redirect_node.text).to eq("/calls/droplet_regions")
        end

        it 'creates a droplet create session' do
          expect { handler.response_text }.to change(DropletCreateSession, :count).from(0).to(1)
          expect(DropletCreateSession.last.session_id).to eq(call_sid)
        end
      end
    end

    context 'Region Select' do
      let(:action) { 'droplet_regions' }

      it 'returns twiml for the regions gather' do
        menu_twiml = handler.response_text
        document = Nokogiri::XML(menu_twiml)

        gather_node = document.at_xpath('.//Gather')

        expect(gather_node[:numDigits]).to eq('1')
        expect(gather_node[:action]).to eq('/calls/select_droplet_region')
        expect(gather_node[:method]).to eq('POST')
        expect(gather_node[:timeout]).to eq('30')

        play_node = gather_node.at_xpath('./Play')
        expect(play_node.text).to eq('/audio/region-select.mp3')
      end
    end

    context 'Set Region' do
      let!(:droplet_create_session) { FactoryGirl.create(:droplet_create_session, session_id: call_sid) }
      let(:params) { super().merge(Digits: '1') }
      let(:action) { 'select_droplet_region' }

      it 'updates the droplet create session to set the region' do
        menu_twiml = handler.response_text
        expect(droplet_create_session.reload.region).to eq('nyc2')
      end

      it 'redirects to the droplet sizes selection menu' do
        menu_twiml = handler.response_text
        document = Nokogiri::XML(menu_twiml)

        redirect_node = document.at_xpath('.//Redirect')
        expect(redirect_node[:method]).to eq('GET')
        expect(redirect_node.text).to eq("/calls/droplet_sizes")
      end
    end

    context 'Size Select' do
      let(:action) { 'droplet_sizes' }

      it 'returns twiml for the sizes gather' do
        menu_twiml = handler.response_text
        document = Nokogiri::XML(menu_twiml)

        gather_node = document.at_xpath('.//Gather')

        expect(gather_node[:numDigits]).to eq('1')
        expect(gather_node[:action]).to eq('/calls/select_droplet_size')
        expect(gather_node[:method]).to eq('POST')
        expect(gather_node[:timeout]).to eq('30')

        play_node = gather_node.at_xpath('./Play')
        expect(play_node.text).to eq('/audio/size-select.mp3')
      end
    end

    context 'Set Region' do
      let!(:droplet_create_session) { FactoryGirl.create(:droplet_create_session, session_id: call_sid) }
      let(:params) { super().merge(Digits: '1') }
      let(:action) { 'select_droplet_size' }

      it 'updates the droplet create session to set the size' do
        menu_twiml = handler.response_text
        expect(droplet_create_session.reload.size).to eq('512mb')
      end

      it 'redirects to the droplet sizes selection menu' do
        menu_twiml = handler.response_text
        document = Nokogiri::XML(menu_twiml)

        redirect_node = document.at_xpath('.//Redirect')
        expect(redirect_node[:method]).to eq('GET')
        expect(redirect_node.text).to eq("/calls/creating_droplet")
      end
    end

    context 'Creating Droplet' do
      let!(:droplet_create_session) { FactoryGirl.create(:droplet_create_session, session_id: call_sid) }
      let(:params) { super().merge(Digits: '1') }
      let(:action) { 'creating_droplet' }

      it 'creates a droplet' do

      end
    end
  end
end