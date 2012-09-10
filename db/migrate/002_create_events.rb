class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.datetime :scheduled_date, :null => false
      t.string :location, :null => false
      t.integer :gathering_id, :null => false
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
