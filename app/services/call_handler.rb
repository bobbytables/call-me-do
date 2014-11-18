class CallHandler
  ALLOWED_HANDLERS = %w(menu menu_option_select droplet_regions select_droplet_region droplet_sizes select_droplet_size create_droplet)
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def action
    params[:action]
  end

  def response_text
    if action.in? ALLOWED_HANDLERS
      send(action).text
    end
  end

  def menu
    Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: '/calls/menu_option_select', method: 'POST', timeout: 30 do |g|
        r.Play "https://s3.amazonaws.com/creativequeries/introduction.mp3"
      end
    end
  end

  def menu_option_select
    if params[:Digits] == '1'
      DropletCreateSession.create!(session_id: params[:CallSid])
      redirect_url = "/calls/droplet_regions"

      Twilio::TwiML::Response.new do |r|
        r.Redirect redirect_url, method: 'GET'
      end
    elsif params[:Digits] == '2'
      Twilio::TwiML::Response.new do |r|
        r.Play "https://s3.amazonaws.com/creativequeries/support.mp3"
        r.Dial do |d|
          d.Number ENV['SUPPORT_PHONE'], timeout: 60
        end
      end
    end
  end

  def droplet_regions
    Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: '/calls/select_droplet_region', method: 'POST', timeout: 30 do |g|
        r.Play 'https://s3.amazonaws.com/creativequeries/region-select.mp3'
      end
    end
  end

  def select_droplet_region
    region = RegionMapper.region_from(params[:Digits])
    create_session = DropletCreateSession.find_by session_id: params[:CallSid]
    create_session.update_attributes(region: region)

    redirect_url = "/calls/droplet_sizes"
    Twilio::TwiML::Response.new do |r|
      r.Redirect redirect_url, method: 'GET'
    end
  end

  def droplet_sizes
    Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: '/calls/select_droplet_size', method: 'POST', timeout: 30 do |g|
        r.Play 'https://s3.amazonaws.com/creativequeries/size-select.mp3'
      end
    end
  end

  def select_droplet_size
    size = SizeMapper.size_from(params[:Digits])
    create_session = DropletCreateSession.find_by session_id: params[:CallSid]
    create_session.update_attributes(size: size)

    redirect_url = "/calls/create_droplet"
    Twilio::TwiML::Response.new do |r|
      r.Redirect redirect_url, method: 'POST'
    end
  end

  def create_droplet
    create_session = DropletCreateSession.find_by session_id: params[:CallSid]
    client = DropletKit::Client.new(access_token: ENV['DO_PAT'])
    droplet = DropletKit::Droplet.new(
      name: 'some-droplet',
      size: create_session.size,
      region: create_session.region,
      image: 'ubuntu-14-04-x64'
    )

    client.droplets.create(droplet)

    Twilio::TwiML::Response.new do |r|
      r.Play 'https://s3.amazonaws.com/creativequeries/finale.mp3'
    end
  end
end