class CreateUserUrls < ActiveRecord::Migration
  def change
    create_table :user_urls do |t|
      t.references :user
      t.references :url
    end
  end
end
