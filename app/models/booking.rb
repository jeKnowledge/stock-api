class Booking < ApplicationRecord
  # Associations
  belongs_to :item
  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_is_after_start_date
  validate :item_not_currently_booked
  validate :waiting_queue_is_not_empty_and_user_is_waiting

  def end_date_is_after_start_date
    if end_date <= start_date
      errors.add(:end_date, 'End date must be after start date.')
    end
  end

  def item_not_currently_booked
    current_booking = self.item&.current_booking
    if current_booking && current_booking != self
      errors.add(:item_already_booked, 'The item is already booked.')
    end
  end

  def waiting_queue_is_not_empty_and_user_is_waiting
    if !item.waiting_queue_entries.empty? && user != item.oldest_waiting_user
      errors.add(:base, 'The item is reserved for another user.')
    end
  end

  def return!
    self.update_attributes!(returned: true)
    self.item.notify_oldest_waiting_user
  end

  def to_s
    ":book: Booking #{self.id} \nBy @#{self.user.slack_handler} from #{self.start_date.strftime("%Y/%m/%d")} to #{self.end_date.strftime("%Y/%m/%d")} \n#{self.returned ? "This item was already returned" : "This item wasn't returned, yet"}\n"
  end
end
