class BookingSerializer < ActiveModel::Serializer
  attributes :user, :start_date, :end_date, :returned, :created_at

  def user
    { name: object.user.name,
      email: object.user.email }
  end
end
