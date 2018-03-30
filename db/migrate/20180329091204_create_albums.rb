class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :title, :null => false
      t.integer :year
      t.string :genre
      t.integer :number_of_tracks
      t.integer :number_of_discs
      t.references :band, foreign_key: true, :null => false

      t.timestamps
    end
  end
end
