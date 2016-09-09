class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :slack_handler, :access_token
end
