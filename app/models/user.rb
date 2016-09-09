class User < ApplicationRecord
  has_secure_password

  before_create :set_access_token

  # Associations 
  has_many :bookings 
  has_many :waiting_queues
  has_many :items, through: :bookings
  has_many :waiting_items, through: :waiting_queues

  # Validations
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true
  validates :password_digest, presence: true
  validates :slack_handler, presence: true

  def expire_access_token!
    self.access_token_expiration_date = Time.now
    self.save!
  end

  def refresh_access_token!
    set_access_token
    self.save!
  end

  def set_access_token
    self.access_token = generate_access_token
    self.access_token_expiration_date = Time.now + 1.days
  end

  def generate_access_token
    loop do
      token = SecureRandom.hex(32)
      break token unless User.exists?(access_token: token)
    end
  end

  def access_token_expired?
    self.access_token_expiration_date < Time.now
  end
end
