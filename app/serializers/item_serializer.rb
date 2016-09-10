class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :booked, :booking_ids

  has_many :bookings
  has_many :waiting_queue_entries, key: :waiting_queue

  def booked
    !object.current_booking.nil?
  end

  def bookings_ids
    object.bookings_ids
  end
end
