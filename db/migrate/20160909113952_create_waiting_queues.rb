class CreateWaitingQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :waiting_queues do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
  end
end
