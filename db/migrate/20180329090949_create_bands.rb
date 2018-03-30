class CreateBands < ActiveRecord::Migration[5.0]
  def change
    create_table :bands do |t|
      t.string :name, :null => false, index: { unique: true }
      t.string :origin
      t.string :website
      t.string :years_active
      t.text :members, :null => false

      t.timestamps
    end
  end
end
