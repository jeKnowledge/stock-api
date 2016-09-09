class WaitingQueueSerializer < ActiveModel::Serializer
  attributes :user, :created_at

  def user
    { name: object.user.name,
      email: object.user.email }
  end
end
