class CreateGatherings < ActiveRecord::Migration
  def change
    create_table :gatherings do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.datetime :scheduled_date, :null => false
      t.string :location

      t.timestamps
    end
  end
end
