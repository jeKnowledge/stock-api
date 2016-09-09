class Booking < ApplicationRecord
  # Associations
  belongs_to :item
  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :item_not_currently_booked
  validate :waiting_queue_is_not_empty_and_user_is_waiting

  def item_not_currently_booked
    current_booking = self.item.current_booking
    if current_booking && current_booking != self
      errors.add(:item_already_booked, 'The item is already booked.')
    end
  end

  def waiting_queue_is_not_empty_and_user_is_waiting
    if !item.waiting_queue_entries.empty? && user != item.oldest_waiting_user
      errors.add(:base, 'The item is reserved for another user')
    end
  end

  def return!
    self.update_attributes!(returned: true)
    self.item.notify_oldest_waiting_user
  end
end
