class User < ApplicationRecord
  # validations
  validates_presence_of :username, :email, :authy_id, :password
end
