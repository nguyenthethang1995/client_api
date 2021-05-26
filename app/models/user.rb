class User < ApplicationRecord
  PARAMS = %i(last_name first_name email)

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  validates :last_name, presence: true
  validates :first_name, presence: true
end
