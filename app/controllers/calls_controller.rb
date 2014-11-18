class CallsController < ApplicationController
  attr_accessor :api_client

  def initialize(*)
    super
    self.api_client = DropletKit::Client.new(access_token: ENV['DO_PAT'])
  end

  # Top level phone menu
  def menu
    render xml: handler.response_text
  end

  def menu_option_select
    render xml: handler.response_text
  end

  def droplet_regions
    render xml: handler.response_text
  end

  def select_droplet_region
    render xml: handler.response_text
  end

  def droplet_sizes
    render xml: handler.response_text
  end

  def select_droplet_size
    render xml: handler.response_text
  end

  def create_droplet
    render xml: handler.response_text
  end

  def contact_support

  end

  def handle_menu
    region_slug = RegionMapper.region_from(params['Digits'])
    gather_path = sizes_calls_path(region: region_slug)

    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: gather_path, method: 'POST' do |g|
        r.Play "http://digitalocean.ngrok.com/audio/region-select.mp3"
      end
    end

    render xml: response
  end

  def sizes
    size_slug = SizeMapper.size_from(params['Digits'])
    region_slug = params[:region]

    gather_path = spinup_calls_path(size: size_slug, region: region_slug)

    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: gather_path, method: 'POST' do |g|
        g.Say 'Which size would you like?'

        SizeMapper::MAPPING.each do |digit, size_slug|
          letters = size_slug.chars.join(' ')
          g.Say "For #{letters}, press #{digit}"
        end
      end
    end

    render_twiml response
  end

  def spinup
    response = Twilio::TwiML::Response.new do |r|
      r.Say "HERE WE GO!"
    end

    droplet = DropletKit::Droplet.new(name: 'your-droplet', size: size_slug, region: region_slug, image: 'ubuntu-14-04-x64')
    api_client.droplets.create(droplet)
  end

  private

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end

  def handler
    CallHandler.new(params)
  end
end