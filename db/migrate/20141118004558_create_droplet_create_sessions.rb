class CreateDropletCreateSessions < ActiveRecord::Migration
  def change
    create_table :droplet_create_sessions do |t|
      t.string :session_id
      t.string :region
      t.string :size
      t.boolean :completed

      t.timestamps
    end
  end
end
