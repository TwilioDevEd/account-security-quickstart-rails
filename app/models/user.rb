class User < ApplicationRecord
  # validations
  validates_presence_of :username, :email, :authyId, :password
end
