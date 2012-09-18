class CreateGatheringUsers < ActiveRecord::Migration
  def change
    create_table :gathering_users do |t|
      t.integer :user_id, :null => false
      t.integer :gathering_id, :null => false
      t.datetime :inactive_at
      t.string :role, :null => false

      t.timestamps
    end
  end
end
