require 'rails_helper'

describe CallsController do
  let(:droplets_resource) { double('droplets resource', create: true) }
  let(:api_client) { double('api client', droplets: droplets_resource) }
end