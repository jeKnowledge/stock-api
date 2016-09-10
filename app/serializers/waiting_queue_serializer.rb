class WaitingQueueSerializer < ActiveModel::Serializer
  attributes :id, :user, :item_id

  def user
    { name: object.user.name,
      email: object.user.email }
  end
end
