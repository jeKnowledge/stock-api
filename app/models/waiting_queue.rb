class WaitingQueue < ApplicationRecord
  # Associations 
  belongs_to :user
  belongs_to :item

  # Validations
  validates :user_id, presence: true
  validates :item_id, presence: true
  # TODO vlaidar um user so pode ter uma qaiting list para o mesmo item
end
