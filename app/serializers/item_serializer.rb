class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :booked

  has_many :bookings, embed: :ids
  has_many :waiting_queue_entries, key: :waiting_queue

  def booked
    !object.current_booking.nil?
  end
end
