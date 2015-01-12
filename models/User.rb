class User < ActiveRecord::Base
	validates :username, :password, presence: true
	validates :username, uniqueness: true
	has_many :games #, :foreign_key => "" Tengo que ponerla?
end