class AddsReturnedToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :returned, :boolean, default: false
  end
end
