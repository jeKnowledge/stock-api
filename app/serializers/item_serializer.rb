class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url, :booked, :current_booking

  has_many :bookings
  has_many :waiting_queue_entries, key: :waiting_queue

  def bookings
    object.bookings.select { |b| b != object.current_booking }
  end

  def waiting_queue_entries
    object.waiting_queue_entries.order(:created_at)
  end

  def booked
    !object.current_booking.nil?
  end

  # TODO improve this
  def current_booking
    if object.current_booking
      { id: object.current_booking.id, 
        start_date: object.current_booking.start_date,
        end_date: object.current_booking.end_date,
        user: { id: object.current_booking.user.id,
                name: object.current_booking.user.name,
                email: object.current_booking.user.email } }
    else
      nil
    end
  end
end
