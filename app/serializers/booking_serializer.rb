class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user, :item_id, :start_date, :end_date, :returned 

  def user
    { id: object.user.id, 
      name: object.user.name,
      email: object.user.email }
  end
end
