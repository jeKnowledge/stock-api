class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :photo_url
  has_many :bookings, embed: :ids
  has_many :waiting_queue_entries, key: :waiting_queue
end
