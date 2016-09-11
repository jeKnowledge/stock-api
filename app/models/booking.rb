class Booking < ApplicationRecord
  # Associations
  belongs_to :item
  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :booking_is_unique_on_time_period, on: :create
  validate :end_date_is_after_start_date 
  validate :item_not_currently_booked
  validate :waiting_queue_is_not_empty_and_user_is_waiting, on: :create

  def booking_is_unique_on_time_period
    if !item.bookings.where("(start_date <= ? AND start_date >= ?) OR (end_date <= ? AND end_date >= ?)", end_date, start_date, end_date, start_date).empty?
      errors.add(:base, 'Item is already booked or partially booked on the time frame given')
    end
  end

  def end_date_is_after_start_date
    if self.end_date <= self.start_date
      errors.add(:end_date, 'must be after start date')
    end
  end

  def item_not_currently_booked
    current_booking = self.item&.current_booking
    if current_booking && current_booking != self
      errors.add(:base, 'Item is already booked')
    end
  end

  def waiting_queue_is_not_empty_and_user_is_waiting
    if !item.waiting_queue_entries.empty? && user != item.oldest_waiting_user
      errors.add(:base, 'Item is reserved for another user')
    end
  end

  def return!
    self.update_attributes!(returned: true,
                            end_date: Time.now)
    self.item.notify_oldest_waiting_user
  end

  def to_s
    ":book: Booking ID *#{self.id}* of item #{self.item.id} \nBy @#{self.user.slack_handler} from #{self.start_date.strftime("%Y/%m/%d")} to #{self.end_date.strftime("%Y/%m/%d")} \n#{self.returned ? "This item was already returned" : "This item wasn't returned, yet"}\n"
  end
end
