FactoryGirl.define do
  factory :droplet_create_session do
    session_id { SecureRandom.uuid }
    region nil
    size nil
    completed false
  end
end
