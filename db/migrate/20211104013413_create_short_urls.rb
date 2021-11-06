class CreateShortUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :short_urls do |t|
      t.integer :user_id
      t.string :url
      t.string :code
      t.integer :clicked_count, default: 0

      t.timestamps
    end
  end
end
