require 'rails_helper'

describe CallsController do
  describe 'GET menu' do
    it 'returns a proper twilio gather for initial call' do
      get :menu
      document = Nokogiri::XML(response.body)

      gather_node = document.at_xpath('.//Gather')
      expect(gather_node).to_not be_nil
      expect(gather_node[:numDigits]).to eq('1')
      expect(gather_node[:action]).to eq(menu_calls_path)
      expect(gather_node[:method]).to eq('POST')
    end

    it 'greets the user' do
      get :menu
      document = Nokogiri::XML(response.body)

      gather_node = document.at_xpath('.//Gather')
      says = gather_node.xpath('./Say')

      expect(says[0].text).to eq("Welcome to Digital Ocean!")
      expect(says[1].text).to eq("To Spin up a droplet, press 1")
    end
  end
end