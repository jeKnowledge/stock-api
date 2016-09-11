class WaitingQueueSerializer < ActiveModel::Serializer
  attributes :id, :user, :item_id

  def user
    { id: object.user.id, 
      name: object.user.name,
      email: object.user.email }
  end
end
