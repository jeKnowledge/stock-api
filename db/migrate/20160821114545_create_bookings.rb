class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :item_id
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
