class WaitingQueue < ApplicationRecord
  # Associations 
  belongs_to :user
  belongs_to :item

  # Validations
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :user_id, uniqueness: { scope: :item_id }
  validate :user_cannot_own_item

  def user_cannot_own_item
    if item.current_owner == user
      error.add(:base, 'You already own the item')
    end
  end
end
