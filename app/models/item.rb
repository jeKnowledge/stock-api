require 'tropo-webapi-ruby'
require 'slack-notifier'

class Item < ApplicationRecord
  # Associations 
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many :waiting_queue_entries, class_name: 'WaitingQueue', dependent: :destroy
  has_many :waiting_users, through: :waiting_queue_entries
  has_many :item_categories, dependent: :destroy
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
    #notify through sms or call
    #tropo = Tropo::Generator.new
    #response = tropo.parse({:network => "SMS"})
    #p 'Hey, this is a text messaging session!' if tropo.text_session
    
    #notify through slack
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#stock', username: 'Bookings'
    notifier.ping "Hello"
  end

  def to_s_show
    "#{self.name} (#{self.id}) Bookings: #{self.bookings.map {|booking| booking.to_s}}"
  end

  def to_s_list
    "Item ID: #{self.id} | Item name: #{self.name}" 
  end
end
