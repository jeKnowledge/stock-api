class WaitingQueueSerializer < ActiveModel::Serializer
  attributes :id, :user, :item_id, :created_at

  def user
    { name: object.user.name,
      email: object.user.email }
  end
end
