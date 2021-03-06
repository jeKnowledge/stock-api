require 'twilio-ruby'
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
    b && !b.returned ? b : nil
  end

  def current_owner
    current_booking ? current_booking.user : nil
  end

  def oldest_waiting_user
    self.waiting_queue_entries.order(:created_at).first&.user
  end

  def notify_oldest_waiting_user
    user_to_warn = self.waiting_queue_entries.order(:created_at).last&.user&.slack_handler
    return if user_to_warn.nil?

    # Slack notifiction 
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#stock', username: 'Bookings'
    notifier.ping "@#{user_to_warn}, the item that you requested, #{self.name} (ID: #{self.id}) is now available!", icon_emoji: ":aw_yeah:", parse: "full"

    # SMS Notification
    # TODO fix hardcoded numbers
    send_text_message

  end

  def to_s_show
    ":package: Item *#{self.name}*, with ID #{self.id} has the following bookings: \n#{self.bookings.map {|booking| booking.to_s}.join("\n")}"
  end

  def to_s_list
    "Item #{self.id} *#{self.name}* #{self.current_booking ? ":x:" : ":white_check_mark:"}" 
  end


  def send_text_message
    twilio_sid = Rails.application.secrets.twilio_sid
    twilio_token = Rails.application.secrets.twilio_token
    twilio_phone_number = "+12013836503 "

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "#{twilio_phone_number}",
      :to => "+351916633324",
      :body => "The #{self.name} with id #{self.id} that you requested is now available."
    )

    @twilio_client.account.sms.messages.create(
      :from => "#{twilio_phone_number}",
      :to => "+351914383365",
      :body => "The #{self.name} with id #{self.id} that you requested is now available."
    )
  end
end
