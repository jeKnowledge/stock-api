class Item < ApplicationRecord
  # Associations 
  has_many :bookings
  has_many :waiting_queue_entries, class_name: 'WaitingQueue'
  has_many :users, through: :bookings
  has_many :waiting_users, through: :waiting_queue_entries
  has_many :item_categories
  has_many :categories, through: :item_categories

  # Validations
  validates :name, presence: true
  validates :photo_url, presence: true

  def current_booking
    b = bookings.order(:created_at).last
    b && (b.end_date > Time.now || !b.returned) ? b : nil
  end

  def current_owner
    current_booking ? current_booking.user : nil
  end

  def oldest_waiting_user
    self.waiting_queue_entries.order(:created_at).first&.user
  end

  def notify_oldest_waiting_user
    # TODO notify SLACK oldest_waiting_user
  end
end
