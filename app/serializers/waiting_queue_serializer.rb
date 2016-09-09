class WaitingQueueSerializer < ActiveModel::Serializer
  attributes :id, :user, :created_at

  def user
    { name: object.user.name,
      email: object.user.email }
  end
end
