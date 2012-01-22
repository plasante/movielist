class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.string :rating
      t.integer :lock_version
      
      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
