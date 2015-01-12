class Status < ActiveRecord::Base
	validates :description, presence: true
	has_many :games
end