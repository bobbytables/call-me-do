class CallsController < ApplicationController
  # Top level phone menu
  def menu
    response = Twilio::TwiML::Response.new do |r|
      r.Gather numDigits: 1, action: '/calls/menu', method: 'POST' do |g|
        r.Say "Welcome to Digital Ocean!"
        r.Say "To Spin up a droplet, press 1"
      end
    end

    render_twiml response
  end

  def handle_menu

  end

  private

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end
end